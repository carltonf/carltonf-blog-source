---
layout: post
title: "Code-Reading: The Racing Of Two Agents"
date: 2016-10-17
last_modified_at: 2016-10-27
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

`gnome-session` does have some documentations oneline. However, they all seem to
be outdated (compared the info I got from the code.). Nevertheless, they still
provide some insights and you can find the [longer version][wiki-GnomeSession]
and [the newer, shorter version][wiki-GnomeSessionTNG] here.

[wiki-GnomeSession]:https://wiki.gnome.org/Projects/SessionManagement/GnomeSession 
[wiki-GnomeSessionTNG]: https://wiki.gnome.org/Projects/SessionManagement/NewGnomeSession

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
back to `GSM_MANAGER_PHASE_RUNNING` in case of failures. Covered in another
[post](#) %}

[enum GsmManagerPhase]: {{page.SP2_GNOME_SESSION}}/gnome-session/gsm-manager.h#L54
[end_phase() phase++]: {{page.SP2_GNOME_SESSION}}/gnome-session/gsm-manager.c#L497

As shown above `Shell` starts at `DisplayServer` phase,
(`X-GNOME-Autostart-Phase=DisplayServer`), much earlier than the
[default][load_desktop_file] `Application` phase. `polkit-gnome` was started at
this default phase as it has no explicit phase setting. So usually, `Shell`
starts and registers itself as agent before `polkit-gnome` can do *anything*.

[load_desktop_file]: {{page.SP2_GNOME_SESSION}}/gnome-session/gsm-autostart-app.c#L614

The autostart condition `GNOME3 unless-session gnome` will be `true` under
`gnome-classic` and thus `polkit-gnome` will start. However, since there is only
one allowed polkit agent, `polkit-gnome` will fail and exit.


## What if there is an saved session

In a `saved session` situation, `gnome-session` will detect the relevant
settings and saved session files under user home directory. It will load saved
`apps` from saved session files **first**, before the normal loading of
`required` and `autostart` apps. {% sidenote sn-loading-order The latter desktop
files would not override earlier desktop files. `gnome-session` use the
`provides` field to decide whether a later loaded desktop file is effective. %}

`org.gnome.Shell`, as saved session file, the desktop entry file does **NOT**
have the autostart phase set to `DisplayServer`, actually, not set at all. So
it's started at `Application` phase, together with `polkit-gnome`.
`polkit-gnome` is a much simpler program and might register itself as `polkit
agent`, while `shell` is still running to get to its `JS` part. 

In observation, with a `saved session`, `polkit-gnome` almost always win as the
real agent.


## What if Shell died

When `Shell` dies, it gets restarted by `gnome-session`. {% sidenote
sn-shell-restart This is not to be confused with the built-in restart as
`Alt-F2, r` would offter, in which case the process itself is not killed. %} The
timing can be unfortunate for it can coincidences with the starting of
`polkit-gnome`, and be outrun by it in registering as polkit agent.


# Debugging

In this section, I will show important questions I asked during debugging and
some useful tips to prove points mentioned in the [Sequence](#sequence).

## `polkit-gnome` starts under `gnome-classic`

To prove this point, two approaches can be taken:

1. Use [Linux Audit].
2. *Manual Injection*. Change the destktop entry file or the executable itself.
   In our case, capture the stdin/stderr are sufficient.

[Linux Audit]: https://www.suse.com/documentation/sles11/singlehtml/audit_quickstart/audit_quickstart.html

It's usually better to use `Audit` first and then empoly `Injection` to get more
details.


### Linux Auditing

This seems to be the only non-intrusive approach. At the cost of complexity,
`Audit` is very powerful and capable of much more.

Make sure all prerequiresites are met {% sidenote sn-audit-post (Yelling!) I
have another post for more detials. Plainning... %}.

``` shell
## Precaution: all commands are executed under root prviliages.

# setup rules, you can optionally add more filter fields, uid might be a good addition.
auditctl -a exit,always -F arch=b64 -S all -F path=/usr/lib/polkit-gnome-authentication-agent-1

# verify the above is the only rule, not necessary but helpful in inspecting the log.
auditctl -l

# Logout and Login back again, in a new terminal, the -ts since time is the time
# *just* before you login. Not necessary but helpful in reducting output size.
ausearch -i -ts 16:10
```

You should see something like:

``` text
----
type=UNKNOWN[1327] msg=audit(10/27/16 16:03:10.518:106) : proctitle="/usr/lib/polkit-gnome-authentication-agent-1" 
type=PATH msg=audit(10/27/16 16:03:10.518:106) : item=1 name=/lib64/ld-linux-x86-64.so.2 inode=38532 dev=00:26 mode=file,755 ouid=root ogid=root rdev=00:00 nametype=NORMAL 
type=PATH msg=audit(10/27/16 16:03:10.518:106) : item=0 name=/usr/lib/polkit-gnome-authentication-agent-1 inode=160885 dev=00:26 mode=file,755 ouid=root ogid=root rdev=00:00 nametype=NORMAL 
type=CWD msg=audit(10/27/16 16:03:10.518:106) :  cwd=/home/vagrant 
type=EXECVE msg=audit(10/27/16 16:03:10.518:106) : argc=1 a0=/usr/lib/polkit-gnome-authentication-agent-1 
type=SYSCALL msg=audit(10/27/16 16:03:10.518:106) : arch=x86_64 syscall=execve success=yes exit=0 a0=0x11be100 a1=0x11be0a0 a2=0x11be150 a3=0xfc2c9fc5 items=2 ppid=1726 pid=1968 auid=vagrant uid=vagrant gid=users euid=
vagrant suid=vagrant fsuid=vagrant egid=users sgid=users fsgid=users tty=(none) ses=91 comm=polkit-gnome-au exe=/usr/lib/polkit-gnome-authentication-agent-1 key=(null) 
```

From the log we can deduce: `ppid=1726` (`ps -up 1726` shows that it's
`gnome-session-binary`) calls `execve` with
`/usr/lib/polkit-gnome-authentication-agent-1` as the sole argument. In other
words, `gnome-session` started `polkit-gnome`.


### Manual Injection

`Linux Auditing` is clean and quick, great for verifying unintend execution.
However, it doesn't capture possible output from processes. For this we would
have to inject extra code into the start sequence. Surely, we can replace
`polkit-gnome-authentication-agent-1` with a custom script, which calls the real
executable only with io rediction to some custom files. However, I'd like to
introduce [systemd-cat] to take full advantage of `journald`.

[systemd-cat]: https://www.freedesktop.org/software/systemd/man/systemd-cat.html

First change the `Exec`{% sidenote sn-exec-line `Exec` line has specific format
requirement, in doubt consult the [documentation][Exec-doc] %} line to something
like:

[Exec-doc]: https://specifications.freedesktop.org/desktop-entry-spec/latest/ar01s06.html

``` ini
# /etc/xdg/autostart/polkit-gnome-authentication-agent-1.desktop
Exec=systemd-cat -t PK-G /usr/lib/polkit-gnome-authentication-agent-1
```

Then use `journalctl -t PK-G` to pick log from `polkit-gnome` out specifically.

``` text
-- Logs begin at Wed 2016-10-26 18:35:03 CST, end at Thu 2016-10-27 16:36:48 CST. --
Oct 27 16:36:44 linux-rblp.suse PK-G[2704]: ** (polkit-gnome-authentication-agent-1:2704): WARNING **: Unable to register authentication agent: GDBus.Error:org.freedesktop.PolicyKit1.Error.Failed: An authentication age
Oct 27 16:36:44 linux-rblp.suse PK-G[2704]: Cannot register authentication agent: GDBus.Error:org.freedesktop.PolicyKit1.Error.Failed: An authentication agent already exists for the given subject
```

## Why `polkit-gnome` started?

The culprit is the condition line `GNOME3 unless-session gnome`. The current
session name referred in this condition can be looked up by introspecting
`org.gnome.SessionManager` object.

{% marginnote mn-session-name %}

Since the naming is not the same for this `session-name`, there were some
confusion at the beginning, as some believed it refering to a `dconf` setting.
It turns out this setting is the *default* if no session type is specified on
the `gnome-session` command line.

{% endmarginnote %}

``` shell
gdbus introspect --session --dest org.gnome.SessionManager \
    --object-path /org/gnome/SessionManager | grep -i session
    
## Output>    readonly s SessionName = 'gnome-classic'

# alternatively you can get to the desired property value directly, though much
# more complicated and not recommended. (And you're to introspect first anyway
# ;P)
gdbus call --session --dest org.gnome.SessionManager \
    --object-path /org/gnome/SessionManager \
    --method org.freedesktop.DBus.Properties.Get \
    org.gnome.SessionManager SessionName

## Output> (<'gnome-classic'>,)
```
