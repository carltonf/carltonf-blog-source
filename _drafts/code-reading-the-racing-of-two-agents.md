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
all the *interesting* stuff within a session. For our purpose, the startup
sequence is of most interest to us.{% sidenote sn-endsession There is a
[Code-Reading](#) post covering the end session part as well. %} Other
components talk back to `gnome-session` through the exported DBus service
`org.gnome.SessionManager`. The term `SessionManager` is used interchangable
with `gnome-session`.

The concept of *a saved session* is also important for our discussion. Bascially
the session will try to save all the opened apps and their states at logout and
restore these saved apps at the next login. There seems to be a protocol(part of
[XSMP](https://www.x.org/releases/X11R7.6/doc/libSM/xsmp.html)) on this saving
behavior, however it doesn't seem to be well-supported among apps, not even
within GNOME. {% sidenote sn-xsmp Much earlier there was a bug about saved
session. The previous investigation convinced me that this feature is deprecated
and not maintained in the upstream. %}

## GNOME Shell (as the first agent, denoted as M)

Normally the agent built into the Shell is what users use. As Shell is the
*required app* for `gnome-session`, it's handled slightly different from other
app, i.e. `gnome-session` will try to restart required app if they die and end
session if a required component failed too often.

1. Required apps are
   [read from session key file](/wiki/ref-code-reading-the-racing-of-two-agents.html#required-apps).
2. On failure, required apps are restarted automatically.


## polkit-gnome (as the other agent, denote as N)

A separate, independent polkit agent that can work outside GNOME ecosystem.


# Sequence

## The normal sequence

## What if Shell died

## What if with an saved session

