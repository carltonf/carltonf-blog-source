---
layout: post
title: "A Linux Guy's Windows Survival Guide"
date: 2016-09-01
last_modified_at: 2016-09-05
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

Powershell?

Cmd itself?

Bash for Windows?

WSL?


## Unix utilities

[ Git for windows ], the portable version feels better. Or maybe we should use
`Cmder`.

Not Cygwin, has too many rough edges that are helpful.


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
