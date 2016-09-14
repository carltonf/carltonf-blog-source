---
layout: post
title: "A Linux Guy's Windows Survival Guide"
date: 2016-09-01
last_modified_at: 2016-09-14
tags:
- windows
- linux
- tools
---

Here I am sharing some of my thoughts on *surviving* in Windows as a Linux guy
(or more generally a command-line lover). This is also from my experience
working with colleagues who have to work with Windows recently.

Not long ago some of my colleagues have updated their gears with a new
[Dell book](http://www.dell.com/us/business/p/precision-m5510-workstation/pd), a
beefy machine but unfortunately the bundled `Nvidia` graphic card has some
unresolved driver issue in `Linux` {% sidenote %}. And thus some of them might have to work
under `Windows` together with Linux VMs, `VirtualBox` usually {% sidenote
sn-virtualbox
[Docker for Windows](https://docs.docker.com/engine/installation/windows/) might
also be a valid option these days. I tried it out on a Windows 10 machine,
amazed by its maturality in
[such short time](https://blog.docker.com/2016/03/docker-for-mac-windows-beta/).
I'm not familiar with
[Hyper-V](https://www.microsoft.com/en-us/cloud-platform/virtualization) and I
have tools deeply integrated with `VirtualBox` to migrate, at least for now. %}.
They need tools on Windows that can compensate the loss of native Linux
environment, improve productivity and etc.


# Tools

## Shell

I think the Shell environment is the most important tool to get right at first.
Though most of the time I work in an SSH-session into a Linux box, there are
situations a native Windows shell can be useful.

**PowerShell**. Admittedly, anyone familiar with Unix shell like `Bash` will
found `PowerShell`
[object pipline](https://msdn.microsoft.com/en-us/powershell/scripting/getting-started/fundamental/understanding-the-windows-powershell-pipeline)
to be *intriguing* but *awkward*. The problem I feel about the object passing is
that most CLI tools, particularly Unix ones, are not designed with `PowerShell`
objects in mind and thus most of the time you are sticking with text pipeline,
and `PowerShell` is not really good for that. {% sidenote sn-powershell The
Object pipeline actually enforces tools to be in `PowerShell` ecosystem. Unless
you plan to invest a lot in `PowerShell`, like what a Windows Server admin might
do, I do not believe it's very useful. %}

[Windows CMD](https://en.wikipedia.org/wiki/Cmd.exe) is old and ubiquitous on
Windows machines. This is in fact my most used native shell on Windows. It's
quite primitive and limited compared to `Bash`, but useful for some simple tasks
and you really want to shell tasks in Windows simple.

**Bash for Windows** There are various ported version of `Bash` on Windows, from
stand-alone [Win-Bash](http://win-bash.sourceforge.net/){% sidenote sn-win-bash
I remember I used to have a PenDrive bundled with some ported Unix tools. (Back
at TP-Link, where most machines are Windows boxes and I tended to move around)
`Win-Bash` is one of them. It's much light-weighted than other options and with
ported `sed`, `grep` and etc, the scripting feels almost the same as in Linux.
Of course, without a decent terminal program, it's not good for interactive use.
%} to full-blown `Cygwin`. As I prefer to keep shell tasks under Windows simple,
`CMD` batch file is usually good enough and works almost everywhere. I seldom
use these `Bash` ports these days. {% sidenote sn-bash-on-windows The most
recent serious use is a
[Bash script](https://github.com/carltonf/vagrantfiles/blob/master/crystal-maker/basebox-packager.sh)
on Windows that package `Vagrant` base box for personal use. That script also
relies on other Unix tools. %}

[Bash on Ubuntu on Windows](https://msdn.microsoft.com/en-us/commandline/wsl/about)
can not really qualify as native shell yet, as it
[can't run Windows executable](https://github.com/Microsoft/BashOnWindows/issues/333).
I've written [a post about it](/post/try-out-bash-on-unbuntu-on-windows).


## Unix utilities

There are many different choices, and I've tried out some of them, like
[UnxUtils](http://unxutils.sourceforge.net/), in my days back at TP-Link. The
biggest issue with these standalone tools is they are not integrated. It's great
to have a standalone ported tool when you just need that tool. But it eventually
degrades into painful management and frustrating search for the lack of some
tools. Arguably, [Cygwin](https://www.cygwin.com/) is the most feature-complete,
integrated toolset out there. Unfortunately, it had too many rough edges back
when I heavily relied on it. I generally avoid it these days. {% sidenote
sn-cygwin One reason I prefer to avoid `Cygwin` is the easy access to powerful
machine. For anything serious enough to consider `Cygwin`, firing up VM is
usually a better and easier choice. %}

[Git for Windows](https://git-scm.com/downloads) has some of the most used Unix
tools bundled for easy use. It offers a portable version. I use the full version
of [Cmder](http://cmder.net/), which integrates `Git for Windows` among other
goodies.


## Better Terminal

Console Host.

[Cmder] and other alikes


## Talk to Linux

Vagrant for better handling of Virtuabox. optional, power tool for savvy player.

SSH, putty, mobaxterm, mosh, secure shell (in Chrome).

SSHFS, Sftp NetDrive and WebDrive.


## Editor

Emacs(`Spacemacs`) for Windows? GVIM?


## Other Power Tools

GUI Tools: X for Windows. VNC Client and etc.


## Learn a bit about Windows

Samba/Home Group.

Computer Manager.

msconfig, dxdiag, winver 


# Verdict

A long list, with some analysis, better factored out into Wiki entries.
