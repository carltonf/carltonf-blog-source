---
layout: post
title: A learning guide GNOME Shell bug fixing
---

An curated list of learning materials, references for GNOME Shell (bug-fixing) developers.

The other day, my team leader asked me to give some guides for new colleagues in the team. I came up with a list of learning materials, references. When composing it, I realized this is also an opportunity to review my work. So here is the guideline list plus my work review.

# Materials

## [D-Bus](https://www.freedesktop.org/wiki/Software/dbus/)

**Master** `D-Bus` is the core RPC mechanism for Linux applications.

1. [D-Bus Tutorial](https://dbus.freedesktop.org/doc/dbus-tutorial.html)
The best introductory material.

2. [D-Bus Intro](https://www.freedesktop.org/wiki/IntroductionToDBus/)
Slightly more theoretical. Read after the first.


## [Freedesktop.org Specs](https://www.freedesktop.org/wiki/Specifications/)

`Freedesktop.org` specs are *NOT* standards but recommendations. Though most DE have chosen to comply with some of these specs, the compliance levels varies. Nevertheless since they are somewhat ubiquitous in GNOME, developers are recommended to know at least the followings:

- Desktop base directory spec: *general*

- Desktop Entry specification: *read carefully*

- The Autostart specification: *general*

- The XSETTINGS:  *general*

- The File URI specification : *general*


## [GNOME Shell Wiki](https://wiki.gnome.org/Projects/GnomeShell)

- General Information:  *Master*, helpful for debugging
- Technology: *general*
- Looking Glass："Master*，need to be proficient.
- Development guide for GNOME Shell：*general*, we do not need all of them


## [JavaScript](http://www.ecma-international.org/default.htm)

I like `JavaScript`, but some do not. However, since GNOME Shell UI part is almost written completely in JavaScript, we all need to know it well.

-  [Javascript: The Good Parts](https://www.amazon.com/JavaScript-Good-Parts-Douglas-Crockford/dp/0596517742)
   The only `JavaScript` book needed for the work (also one of the best JS books out there). The `JavaScript` engine used by GNOME Shell is [SpiderMonkey](https://developer.mozilla.org/en-US/docs/Mozilla/Projects/SpiderMonkey), version 24, a relatively recent JS engine. However, GNOME has only utilized a small set of JS features in a C-like way.

-  Online references: [MDN](https://developer.mozilla.org/en-US/) is great. Another site I've used often is [Devdocs.io](http://devdocs.io/), a site of many curated docs.

## [X.org](https://www.x.org/)

You really do not want to learn too much about `X`, but you really need to learn much about it. Despite [the mess](http://www.phoronix.com/scan.php?page=article&item=x_wayland_situation&num=1), `X` is still the dominatory (if not the only viable option, yes, I'm talking about you, [Wayland](https://wayland.freedesktop.org/)) display technology in Linux Desktop. For us, X is too arcane to dive deep, too important to ignore. I would recommend the book [X Power Tools](https://www.amazon.com/X-Power-Tools-Chris-Tyler-ebook/dp/B0028N4W9W/) for the introduction.

## [GNOME 3 Application Development Beginner's Guide](https://www.amazon.com/GNOME-Application-Development-Beginners-Guide-ebook/dp/B00AV5OXUM/)

A book I only recommend because it has some content of high relevance to our work.  In general, do not bother with `vala`, `anjuta`, `Gtk+` if you only work with Shell UI. And read the following chapters first, other parts are not recommended though.

   - Chapter 3
   - Chapter 4
   - Chapter 10
   - Chapter 11: *general*

(sidenote) This book was the one my old team leader recommended to me, 3 years ago. There was a [Chinese translation project](https://github.com/beijinggug/gnome3-app-book) for it as well. I was listed as an translator, but never found enough interests to really work on it. The project itself seems to be abandoned long ago as well.


# Recommended Learning Order

["道生一, 一生二，二生三，三生万物".](http://baike.baidu.com/view/9647254.htm)
Things have to come in order.

Given my experience, I think the following order is proper for a beginer:

1. GNOME Shell Main Wiki
2. D-Bus Tutorial
3. GNOME 3 Application Development Beginner's Guide: the recommended parts.
4. X Power Tool:  really worth reading, but can be hard at the beginning.

