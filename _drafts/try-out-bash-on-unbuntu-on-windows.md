---
layout: post
title: try out bash on unbuntu on windows
last_modified_at: 2016-08-25
date: 2016-08-25
---

[Windows Subsystem for Linux](https://en.wikipedia.org/wiki/Windows_Subsystem_for_Linux)
is the new *toy* Microsoft brings to developers. I have played it for one day.
It's still not good enough for daily use, but a possible alternative when
necessary.

Not long ago Windows 10 has released its
[Anniversary Update](http://www.howtogeek.com/248177/whats-new-in-windows-10s-anniversary-update/),
I've waited till it's in the official update channel{% sidenote sn-update To be
honest, I have little confidence that an Windows 10 update would not cause some
regression. Anniversary Update is no exception, there are issues like the
machine can not wake up from hibernation, double authorization required by
Windows Hello and etc. %}. It's still beta, and I didn't put it into serious
use.

# Installation

Ever since *WSL* appeared in the *Insider* channel, there were many articles
covering the installation. The installation from the official update channel is
almost the same. It's very easy and smooth {% sidenote sn-update-smoothness
Hmmm... maybe worth mentioning, I've updated two machines to the Anniversary
Update, one of them caused `VirtualBox` break. Reinstalling `VirtualBox` fixed
it. %}. CLI tools like `lxrun /install /y` are really nice.


# Usage

Packages can be installed from official `Ubuntu` repo. One thing suspicious is
the lack of many `Ubuntu` mirrors in the repo mirror list. Maybe it's due to the
fact that `WSL` is still `Beta`?

To my surprise, `tmux` is pre-installed. The default console host is not to my taste
and I tried to run `rxvt-unicode`, failed with errors of missing `tty` file and
etc. This is understandable, not much has been done for things under `/dev`.

Then I tried to `ping` and it didn't work due to some permission issue.

GUI-Emacs has failed to work, but `Spacemacs` can almost work. The vanilla
`Emacs` window shows up but didn't react to any input. `Spacemacs` start
normally but the window can not be resized, startup parameters like `geometry`
settings doesn't work. {% sidenote sn-spacemacs-works The fact that `Spacemacs`
can "work" but the vanilla one doesn't is really intriguing, though I didn't
spend effort to investigate the cause. %} I've followed threads like
[this](https://www.reddit.com/r/Windows10/comments/4ea4w4/fyi_you_can_run_gui_linux_apps_from_bash/)
to install [VcXsrv](https://sourceforge.net/projects/vcxsrv/) {% sidenote
sn-vcxsrv `VcXsrv` is an open source fork of
[Xming](https://sourceforge.net/projects/xming/). The latter has stopped
updating its open source version in favour of subscription-based support and has
some rough edges fixed in `VcXsrv`. `Xming` seems to be better known, while I
find `VcXsrv` is easier to use. %}

I've also tried `vim-gtk` and it does work. `gvim` seems to be the most taunted
working `GUI` application on `WSL`.

`node` and `npm` can be used normally. At least my small personal projects have
run smoothly. It did have some errors at the start, run `npm config set
unsafe-perm=true` as suggested in
[this issue](https://github.com/Microsoft/BashOnWindows/issues/14) and the rest
went without any further issues.


# Verdict 

For sure, I will not give up my *boxerized* environment {% sidenote
sn-boxerized-post Hmmm...where is my long planned post on this setting? %} for
`WSL`. It can not replace useful Windows tools like [cmder](http://cmder.net/)
and Emacs on Windows either, so I'll not use it in my work or personal projects.
`node` seems to be a good thing to have but `node` can run on `Windows` already
and web service stuff might encounter network permission issues like `ping` down
the road.


# *Cynical Speculation*

Despite recent high-profile open source activities from `Microsoft` {% sidenote
sn-ms-opensource [Visual Studio Code](https://github.com/Microsoft/vscode/),
[TypeScript](https://github.com/Microsoft/TypeScript),
[ChakraCore](https://github.com/Microsoft/ChakraCore) to name some of the most
popular. %}, `WSL` is not open source. This might due to the close integration
with the Windows kernel. Understandable? maybe, but it's a disappointment
nevertheless. Some [discussions](https://news.ycombinator.com/item?id=11445301)
online also shows that this is not the first time Microsoft tries to do
something like this.

My gut feelings is that Microsoft is staging a show here. All in the effort to
put `Windows` back into developers' mind and back onto the focus of IT news.
Just looks at the published name used in media - `Bash on Ubuntu on Windows`,
what a mouthful, lousy name! But it is carefully picked, and sorted in terms'
popularity in developers' mind: `Bash`, `Ubuntu` and `Windows` - A bad name on
its own right, a good marketing strategy in today's IT context. `Windows`
piggybacks upon `Bash` and `Ubuntu` to have a come back. Just like someone joked
on the web about `WSL`: it's "Linux without the Linux part" or "GNU/NT". {%
sidenote sn-gnu-nt Someone followed up: "Richard Stallman must be so proud." %}

However, it's still an interesting show, and despite the caution for investing
on this `WSL` thing, the sheer number of issues at
[Github](https://github.com/Microsoft/BashOnWindows/issues) have shown that
there are people can benefit from `WSL`.
