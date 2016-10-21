---
layout: post
title: "Code-Reading: The Racing Of Two Agents"
date: 2016-10-17
last_modified_at: 2016-10-21
tags:
- code-reading
- sle
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

The concept of *a saved session* is also important for our discussion. Bascially
the session will try to save all the open apps and their *states* upon logout and
restores these saved apps at the next login. There seems to be a protocol(part of
[XSMP](https://www.x.org/releases/X11R7.6/doc/libSM/xsmp.html)) on this saving
behavior, however it doesn't seem to be well supported among apps, not even
within GNOME. {% sidenote sn-xsmp Much earlier there was a bug about saved
session. The previous investigation convinced me that this feature is deprecated
and not maintained in the upstream. %}

## GNOME Shell (denoted as B) 

{% marginnote mn-denotation %} 

**B** stands for *Black*, while **W** stands for
*White*. This is from the fact that the _default_ theming of shell-agent
authentication diaglog is black, while the diaglog from `polkit-gnome` is white. 

{% endmarginnote %}

Normally the agent built into the Shell is what users use. As Shell is the
*required app* (and thus an *autostart app*) for `gnome-session`, it's handled
slightly different from other *clients*, i.e. `gnome-session` will try to
restart these apps if they die and end the current session if a required
component fails too often.

1. Required apps are
   [read from session key file](/wiki/ref-code-reading-the-racing-of-two-agents.html#required-apps).
2. On failure, required apps are restarted automatically.


## polkit-gnome (denoted as W)

A separate, independent polkit agent that can work outside GNOME ecosystem. The
executable, named `polkit-gnome-authentication-agent-1`, installed under
`@LIBDIR` (usually `/usr/share/lib/`).

The current distribution still ships an autostart desktop file. {% sidenote
sn-pkgnome-desktop The earliest entry in the changelog on this desktop file is
"Add as a source a .desktop file to start polkit agent: it was removed from
tarball, but we still need it."
[Here](https://github.com/GNOME/PolicyKit-gnome/commit/47ca445decf21b8de13d804b870d6ce171bad306)
seems to be the upstream commit that removes this file. %} Much of the problem
is caused by this file and its content is worthy full citation here:

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
'`GNOME3` but not `gnome`'. {% sidenote sn-GNOME3-not-gnome I was going to say
`gnome-fallback`, which was *discontinued* around the time `GNOME` 3.10 was
released, and thus coincides with the dev&release of `SLE-12`, `REHL 7` and etc.
However, a little search has surprised me that `gnome-fallback` was alive as
[gnome-flashback](https://wiki.gnome.org/Projects/GnomeFlashback) for quite a
while (it's [official](https://git.gnome.org/browse/gnome-flashback/))! The
history about `GNOME 3`, `fallback`, `classic` and `flashback` is
convoluting, and I found
[this post](https://ubuntuforums.org/showthread.php?t=2185161) more or less
match what I know. Now I'm starting to wonder whether `flashback` will make a
*comeback* in distributions like `SLE` or `RHEL`! %}

# Sequence

## The normal sequence

## What if Shell died

## What if with an saved session

