---
layout: post
title: A learning guide for GNOME Shell bug fixing
tags: [gnome, bug-fix]
last_modified_at: 2016-08-12
---

A curated list of learning materials, references for GNOME Shell (bug-fixing)
developers -- *very* pragmatic.

The other day, my team leader asked me to give some guide for new colleagues in
the team. I came up with a list of learning materials, references *with strong
personal opinions* {% sidenote sn-strong-opined Any sane GNOME developers might
scream at the incompleteness of the list. %}. After passing the list to the new
member, I realized this is also an opportunity to review my understanding. So
here is the guideline list plus my review.

**Some Conventions**: different materials have different importance. I didn't
bother going into fine grades of proficiency level. {% sidenote
sn-proficiency-level This recalls the memory about the college entry exam, when
every student was supposed to know the required proficiency level of every
knowledge. %} Only two levels are used: **Master** and **General**.


# Materials

## [D-Bus](https://www.freedesktop.org/wiki/Software/dbus/)

**Master** 

`D-Bus` is the core RPC mechanism for Linux applications. As with any RPC
mechanism, it's unlikely you'll love it. Its syntax is bewildering and verbose;
few supportive tools are of relatively low quality -- merely usable. Anyway, you
still need to know it well for its ubiquity in gnome. 

{% marginnote mn-kdbus %} `DBus` would have been much more important if the
kernel module [kdbus](https://www.freedesktop.org/wiki/Software/systemd/kdbus/)
had been merged into kernel. The farthest progress it made was into
`kernel-next`. I've read some articles at at
[phoronix](http://www.phoronix.com/scan.php?page=search&q=KDBUS) talking about
the main obstacle was about the security. As a mere side looker, I'll not say
more. {% endmarginnote %}

1. [D-Bus Tutorial](https://dbus.freedesktop.org/doc/dbus-tutorial.html)

   The best introductory material.

2. [D-Bus Intro](https://www.freedesktop.org/wiki/IntroductionToDBus/)

   Slightly more theoretical. Read after the first.


## [Freedesktop.org Specs](https://www.freedesktop.org/wiki/Specifications/)

`Freedesktop.org` specs are *NOT* standards but *recommendations*. Though most
DEs have chosen to comply with **some** of these specs, the compliance level varies.
Nevertheless, since they are somewhat ubiquitous in GNOME, developers are
recommended to know at least the followings:

- Desktop base directory spec: *Master*
- Desktop Entry specification: *Master*
- The Autostart specification: *General*
- The XSETTINGS:  *General*
- The File URI specification : *General*

Most of these recommendations are relatively small and the *Master* level
would require less than one day to achieve.


## [GNOME Shell Wiki](https://wiki.gnome.org/Projects/GnomeShell)

The main hub for GNOME-specific knowledge. Here I've listed some more important
ones: {%sidenote sn-gnome-wiki Things *might* have improved much these days. For
a long time, only some C libraries have some decent API documents. The
introspection bindings to `Gjs` is not complete but only a pragmatic subset.
Shell UI components are completely undocumented and have no external API for
programming/theming. Code and Wiki might be the only official *documents* for
whatever the help they might offer. %}

- General Information:  *Master*, helpful for debugging
- Technology: *General*, you need to know the capacity of each component.
- Looking Glass：*Master*. Not as useful as it claims to be but this is only
  built-in tool we have.
- Development guide for GNOME Shell：*General*, this is more about feature
  development and upstream involvement.


## [JavaScript](http://www.ecma-international.org/default.htm)

I like `JavaScript`, but some do not. However, since GNOME Shell UI part is
almost written completely in JavaScript, we all need to know it well.

- [JavaScript: The Good Parts](https://www.amazon.com/JavaScript-Good-Parts-Douglas-Crockford/dp/0596517742)
  
  The only `JavaScript` book needed for the work (also one of the best JS books
  out there). The `JavaScript` engine used by GNOME Shell is
  [SpiderMonkey](https://developer.mozilla.org/en-US/docs/Mozilla/Projects/SpiderMonkey),
  version 24 {% sidenote sn-spidermonkey-version Previous SP1, i.e. GNOME 3.10.x
  is shipped with version 17. %}, a relatively recent JS engine. However, GNOME has
  only utilized a small set of JS features in a C-like way.

- [JavaScript: the Definitive Guide](https://www.amazon.com/JavaScript-Definitive-Guide-Activate-Guides-ebook/dp/B004XQX4K0).

  **Not Recommended** This may be the most popular book known to beginners.
  However, it's popular for reasons irrelevant to us. The major part (about 70%)
  of the book is about client-side JavaScript, the JavaScript that runes in the
  browser. This book became popular when the language was still condemned to be *the
  shell scripting* for web pages, long before `JavaScript` rose up as a
  superstar language. So even for the client side part, much is deprecated in
  today's practice. Plus, the last version (6th) is from 2011, though not
  outdated for our purpose.

- Online references: [MDN](https://developer.mozilla.org/en-US/) is great.
  Another site I've used often is [Devdocs.io](http://devdocs.io/), which has
  many other docs.


## [X.org](https://www.x.org/)

You really do not want to learn too much about `X`, but you really need to learn
much about it. Despite
[the mess](http://www.phoronix.com/scan.php?page=article&item=x_wayland_situation&num=1),
`X` is still the dominant {% sidenote sn-waylang If not the only viable option,
[Wayland](https://wayland.freedesktop.org/) is still far from being an feasible
alternative. %} display technology in Linux Desktop. For us, `X` is too arcane
to dive deep, too important to ignore. I would recommend the book
[X Power Tools](https://www.amazon.com/X-Power-Tools-Chris-Tyler-ebook/dp/B0028N4W9W/)
for the introduction. {% sidenote sn-x-power This book is not only about X, but
also covers the whole Desktop software stack. Personally, I would recommend the
whole book. %}


## [GNOME 3 Application Development Beginner's Guide](https://www.amazon.com/GNOME-Application-Development-Beginners-Guide-ebook/dp/B00AV5OXUM/)

A book I only recommend because its high relevance to our
work. In general, do not bother with `vala`, `anjuta`, `Gtk+` if you only work
with Shell UI. And read the following chapters first, other parts are not
recommended though.

   - Chapter 3
   - Chapter 4
   - Chapter 10
   - Chapter 11: *General*

{% marginnote mn-gnome-book %} This book was the one my old team leader
recommended to me, 3 years ago. There was a
[Chinese translation project](https://github.com/beijinggug/gnome3-app-book) for
it as well. I was listed as an translator, but never found enough interests to
really work on it. The project itself seems to be abandoned long ago as well
with only the first translated chapter released. {% endmarginnote %}

With the breaking changes introduced in each GNOME 3 releases, many examples
might not work at all. It's not recommended to try to fix those demos as they
might depend on internal Shell implementation and thus hard to fix. The book
uses [seed](https://wiki.gnome.org/action/show/Projects/Seed), the rumored next
JS binding for GNOME. `seed` has not replaced
[gjs](https://wiki.gnome.org/action/show/Projects/Gjs), maybe
[never will](http://ftp.gnome.org/pub/GNOME/sources/seed/). Before
[the latest update](https://www.roojs.org/index.php/projects/gnome/introspection-docs.html),
it is the only one that has some documents.


## [SLE Classic](https://bitbucket.org/carltonf/sle-classic)

This part is actually about a SUSE-specific GNOME feature.

At the beginning of `SLE 12` development, the drastic deviation of `GNOME 3`
from old desktop design of `GNOME 2` (in `SLE 11`) was considered a regression
for users. {% sidenote sn-gnome3-choice In case you are curious about why `GNOME
3` was picked back then, the answer is very *human*: the remaining staff at
Desktop Department were only familiar with `GNOME`. The irony is that `GNOME 3`
is anything but a familiar `GNOME`. %} To tackle this issue, a feature was
proposed which is basically an incarnation of `SLE 11` desktop look&feel. {%
sidenote sn-other-gnomelikes For the record, [Mate](http://mate-desktop.com/)
and [Cinnamon](https://github.com/linuxmint/Cinnamon) are popular GNOME-forked
desktops which have done a much better job in preserving the traditional desktop
design. The reason not to pick one of them was the concern over upstream
community support. I'll avoid another irony comment ;P %}

The repo at [Bitbucket](https://bitbucket.org/carltonf/sle-classic) was my
personal repo to track the development of `SLE Classic`. It has some useful
notes and can serve a good reference for maintaining `SLE Classic`. The commit
log might also be of some interest but the old history is incomplete and
convoluted as I was also beginner back then. At present, I believe it is merely
an interim hack to help users migrate to newer desktop and should be
discontinued in future `SLE` releases.


# Recommended Learning Order

{% marginnote mn-things-in-order %}
["道生一, 一生二，二生三，三生万物".](http://baike.baidu.com/view/9647254.htm)
{% endmarginnote %}

Things have to come in order.

I think the following order is appropriate for a beginner:

1. GNOME Shell Main Wiki
2. D-Bus Tutorial
3. JavaScript core
4. GNOME 3 Application Development Beginner's Guide: the recommended parts.
5. X Power Tool:  really worth reading, but can be hard at the beginning.
