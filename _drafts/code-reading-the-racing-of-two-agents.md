---
layout: post
title: "Code-Reading: The Racing Of Two Agents"
date: 2016-10-17
last_modified_at: 2016-10-25
tags:
- code-reading
- sle
SP2_GNOME_SESSION: 'https://github.com/GNOME/gnome-session/tree/eba0460033804d2d5ce60953c76fd75f396cc43e'
SP2_GNOME_SHELL: 'https://github.com/GNOME/gnome-shell/tree/3.20.4'
---

From a bug due to a race condition between two polkit agents, this post explain
the handling of the startup components and autostart apps within `gnome-session`.

# Components

## GNOME Session

Other than the X server, `gnome-session`{% sidenote sn-gs-name In SP2, the `comm` is
actually called `gnome-session-binary` which is `exec`-ed from a shell script
called `gnome-session`. This indirection is meant to solve a environment passing
bug. A very interesting problem worth a separate post. %} is the daemon managing
all the *interesting* stuff within a *session*. For our purpose, the startup
sequence is of most interest to us.{% sidenote sn-endsession There is a
[Code-Reading(PLANNED)](#) post covering the end session part as well. %} Other
components talk back to `gnome-session` through the exported DBus service
`org.gnome.SessionManager`. The term `SessionManager` is used interchangable
with `gnome-session`.

### Saved Session

The concept of *a saved session* is also important for our discussion. Bascially
the session will try to save all the open apps and their *states* upon logout
and restores these saved apps at the next login. There seems to be a
protocol(part of [XSMP]) on this saving behavior, however it doesn't seem to be
well supported among apps, not even within GNOME. {% sidenote sn-xsmp Much
earlier there was a bug about saved sessions. The previous investigation
convinced me that this feature is deprecated and not maintained in the upstream.
%}

[XSMP]: https://www.x.org/releases/X11R7.6/doc/libSM/xsmp.html

Without delving into details about `XSMP`, it's sufficient to show saved
session's desktop files here:

**TODO** normal app desktop, shell desktop files


## GNOME Shell

Normally the agent [built into][polkitAgent.js] the Shell is what users use. As
Shell is the *required app* (and thus an *autostart app*) for `gnome-session`,
it's handled slightly different from other *clients*, i.e. `gnome-session` will
try to restart these apps if they die and end the current session if a required
component fails too often. {% sidenote sn-required-app Q: Is this really the
specialty for *required app*? Further, I'm puzzled by the line
`X-GNOME-AutoRestart=false`. %}

1. Required apps are defined in [session key file][e.g. GNOME Session] by
   [searching predefined locations][find_valid_session_keyfile].
2. On failure, required apps are restarted automatically. Until a limit is
   reached, the whole session ends with failure.
3. The naming for `GNOME Shell` as a component is [org.gnome.Shell]. However,
   it's worth citing the desktop file here:

``` ini
[Desktop Entry]
Type=Application
_Name=GNOME Shell
_Comment=Window management and application launching
Exec=@bindir@/gnome-shell
# ...
NoDisplay=true
X-GNOME-Autostart-Phase=DisplayServer
X-GNOME-Provides=panel;windowmanager;
X-GNOME-Autostart-Notify=true
X-GNOME-AutoRestart=false
```

[polkitAgent.js]: {{page.SP2_GNOME_SHELL}}/js/ui/components/polkitAgent.js
[e.g. GNOME Session]: {{page.SP2_GNOME_SESSION}}/data/gnome.session.desktop.in.in
[find_valid_session_keyfile]: {{page.SP2_GNOME_SESSION}}/gnome-session/gsm-session-fill.c#L206
[org.gnome.Shell]: {{page.SP2_GNOME_SHELL}}/data/org.gnome.Shell.desktop.in.in


## `polkit-gnome` 

A separate, independent polkit agent that can work outside GNOME ecosystem. The
executable, named `polkit-gnome-authentication-agent-1`, installed under
`@LIBDIR` (usually `/usr/share/lib/`).

The current distribution still ships an autostart desktop file. {% sidenote
sn-pkgnome-desktop The earliest entry in the changelog on this desktop file is
*"Add as a source a .desktop file to start polkit agent: it was removed from
tarball, but we still need it."* [Here][removal-commit] seems to be the upstream
commit that removed this file. %} Much of the problem is caused by this file and
its content is worthy full citation here:

[removal-commit]: https://github.com/GNOME/PolicyKit-gnome/commit/47ca445decf21b8de13d804b870d6ce171bad306

```ini
# polkit-gnome-authentication-agent-1.desktop.in
[Desktop Entry]
Name=PolicyKit Authentication Agent
# ...
Comment=PolicyKit Authentication Agent
# ...
Exec=@LIBDIR@/polkit-gnome-authentication-agent-1
Terminal=false
Type=Application
Categories=
NoDisplay=true
NotShowIn=KDE;
AutostartCondition=GNOME3 unless-session gnome
```

The `AutostartCondition` doesn't seem to be well documented, but it means that
this agent should be automatically started on login if the session *is of*
'`GNOME3` but not `gnome`'{% sidenote sn-GNOME3-not-gnome I was going to say
`gnome-fallback`, which was *discontinued* around the time `GNOME` 3.10 was
released, and thus coincides with the dev&release of `SLE-12`, `REHL 7` and etc.
However, a little search has surprised me that `gnome-fallback` was alive as
[gnome-flashback] for quite a while (it's
[official][gnome-flashback official repo])! The history about `GNOME 3`,
`fallback`, `classic` and `flashback` is convoluting, and I found
[this post][the history of fallback and its likes] more or less match what I
know. Now I'm starting to wonder whether `flashback` will make a *comeback*! %}.

[gnome-flashback]: https://wiki.gnome.org/Projects/GnomeFlashback
[gnome-flashback official repo]: https://git.gnome.org/browse/gnome-flashback/
[the history of fallback and its likes]: https://ubuntuforums.org/showthread.php?t=2185161

# Sequence

Before describing each sequence in details, we explain the symptom as seen in the
bug. The _default_ theming of `shell-agent` authentication diaglog is **black**,
while the diaglog from `polkit-gnome` is **white**. This makes the issue
ostentatious, easily catched by [openQA](https://openqa.opensuse.org/): the
usual black dialogue is not found instead the white dialog is shown.

## The normal sequence

`SessionManager` has internal [`phases`][enum GsmManagerPhase], which follows a
*nearly* [linear style][end_phase() phase++] of state transitions. {% sidenote
sn-linear-state A notable exception is during ending session
(logout/reboot/shutdown),`GSM_MANAGER_PHASE_QUERY_END_SESSION` can transition
back to `GSM_MANAGER_PHASE_RUNNING` in case of failures. Covered in another [post](#) %}

[enum GsmManagerPhase]: {{page.SP2_GNOME_SESSION}}/gnome-session/gsm-manager.h#L54
[end_phase() phase++]: {{page.SP2_GNOME_SESSION}}/gnome-session/gsm-manager.c#L497

As shown above `Shell` starts at `DisplayServer` phase,
(`X-GNOME-Autostart-Phase=DisplayServer`), much earlier the
[default][load_desktop_file] `Application` phase.

[load_desktop_file]: {{page.SP2_GNOME_SESSION}}/gnome-session/gsm-autostart-app.c#L614
    
## What if Shell died

## What if with an saved session

