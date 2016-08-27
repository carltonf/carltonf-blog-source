---
layout: post
title: Try Out Bash on Unbuntu on Windows
last_modified_at: 2016-08-27
date: 2016-08-27
tags: 
- windows
- bash
- ubuntu
---

[Windows Subsystem for Linux](https://en.wikipedia.org/wiki/Windows_Subsystem_for_Linux)
is the new *toy* Microsoft brings to developers. Having played it for one day,
I feel it's still not good enough for daily use, but a possible alternative when
necessary.

Not long ago, Windows 10 has released its
[Anniversary Update](http://www.howtogeek.com/248177/whats-new-in-windows-10s-anniversary-update/),
I've waited till it's in the official update channel{% sidenote sn-update To be
honest, I have little confidence that an Windows 10 update would not cause some
regression. Anniversary Update is no exception, there are issues like the
machine can not wake up from hibernation, double authorization required by
Windows Hello and etc. %}. It's still beta, and thus I didn't expect very much
from it.


# Installation

Ever since *WSL* appeared in the *Insider* preview channel, there were many
articles covering the installation. The installation from the official update
channel remains almost the same as in preview. It's very easy and smooth {%
sidenote sn-update-smoothness Hmmm... maybe worth mentioning, I've updated two
machines to the Anniversary Update, one of them breaked `VirtualBox`.
Reinstalling `VirtualBox` fixed it. %}. CLI tools like `lxrun` are really nice.


# Usage

Packages can be installed from the official `Ubuntu` repo. One thing suspicious is
the lack of many `Ubuntu` mirrors in the repo mirror list. Maybe it's due to the
fact that `WSL` is still `Beta`?

To my surprise, `tmux` is pre-installed. The default console host is not to my taste
and I tried to run `rxvt-unicode`, which failed with errors about missing `tty` files and
etc. This is understandable, not much has been done for things under `/dev`.

Then I tried to `ping` and it didn't work for some permission issues.

GUI-Emacs failed to work {% sidenote sn-cli-emacs The CLI version worked without
a problem, but in terminal I actually prefer `vim` over `Emacs`. %}, but
GUI-`Spacemacs` can almost work. The vanilla `Emacs` window showed up but didn't
react to any input. `Spacemacs` started normally but the window could not be
resized, startup parameters like `geometry` settings didn't work. {% sidenote
sn-spacemacs-works The fact that `Spacemacs` can "work" but the vanilla one
doesn't is really intriguing, though I didn't spend effort to investigate the
cause. %} I've followed threads like
[this one](https://www.reddit.com/r/Windows10/comments/4ea4w4/fyi_you_can_run_gui_linux_apps_from_bash/)
to install [VcXsrv](https://sourceforge.net/projects/vcxsrv/) {% sidenote
sn-vcxsrv `VcXsrv` is an open source fork of
[Xming](https://sourceforge.net/projects/xming/). The latter has stopped
updating its open source version in favour of subscription-based support and has
some rough edges, which get fixed in `VcXsrv`. `Xming` seems to be better known,
while I find `VcXsrv` is easier to use. %}.

I've also tried `vim-gtk` and it did work. `gvim` seems to be the most taunted
working `GUI` application on `WSL`.

`node` and `npm` can be used normally. At least my small personal projects had
run smoothly. It did have some errors at the start, run "`npm config set
unsafe-perm=true`" as suggested in
[this issue](https://github.com/Microsoft/BashOnWindows/issues/14) and the rest
went without any further issues.

I didn't try crazy things like
[ a full DE ](https://www.reddit.com/r/Windows10/comments/4kkamr/so_with_wsl_you_can_run_gui_apps_window_managers/)
on `WSL`, but those brave projects are fascinating.


# Verdict 

For sure, I will not give up my *boxerized* environment {% sidenote
sn-boxerized-post Hmmm...where is my long planned post on this setting? %} for
`WSL`. It can not replace useful Windows tools like [cmder](http://cmder.net/)
and Emacs on Windows either, so I'll not use it in my work or personal projects.
`node` seems to be a good thing to have but `node` can natively run on `Windows`
already and web service stuff might encounter network permission issues like
`ping` down the road.


# *Cynical Speculation*

Despite recent high-profile open source activities from `Microsoft` {% sidenote
sn-ms-opensource [Visual Studio Code](https://github.com/Microsoft/vscode/),
[TypeScript](https://github.com/Microsoft/TypeScript),
[ChakraCore](https://github.com/Microsoft/ChakraCore) to name some of the most
popular. %}, `WSL` is not open source. This might root from the close integration
with the Windows kernel. Understandable? Maybe, but it's a disappointment
nevertheless. Some [discussions](https://news.ycombinator.com/item?id=11445301)
online also shows that this is not the first time Microsoft tries to do
something like this.

My gut feelings is that Microsoft is just staging a show here. All in the effort
to put `Windows` back into developers' mind and back onto the focus of media.
Just looks at the published name used in media - `Bash on Ubuntu on Windows`,
what a mouthful, lousy name! But it is carefully picked, and sorted in terms'
popularity in developers' mind: `Bash`, `Ubuntu` and `Windows` - A bad name on
its own right, a good marketing strategy in today's IT context. `Windows`
piggybacks upon `Bash` and `Ubuntu` to try to have a come back. Just like
someone joked on the web about `WSL`: it's "*Linux without the Linux part*" or
"GNU/NT". {% sidenote sn-gnu-nt Someone followed up: "Richard Stallman must be
so proud." ;P %}

However, it's still an interesting show, and despite the caution for investing
on this `WSL` thing, the sheer number of issues at
[Github](https://github.com/Microsoft/BashOnWindows/issues) have shown that
there are people can benefit from `WSL`.
