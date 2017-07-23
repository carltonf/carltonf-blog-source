---
layout: post
title: "Symbolic links on Windows"
date: 2017-07-16
last_modified_at:
tags:
- tech
- cygwin
- symlink
---

Symbolic link is a very convenient facility to organize your files. When using
`Bash` on Windows, there are multiple options that simulate the native symlink
as on Linux. This post records my experience with them and also some other
useful tips.

Due to some limitations of `MobaXterm` {% sidenote sn-id `MobaXterm` notably
lacks proper `tty` setup, but `cmder` has its own problems as well. %}, I
started to use `cmder` for some tasks again. One thing I noticed is that the
`ln` bundled together in the `Git4Win` is merely a `cp`, essentially making `ln`
not usable at all. {% sidenote sn-ln-in-msys2 Why they (Msys2) would ship such a
version in the first place is still a mystery to me. %} Since `MobaXterm` by
default would create a special file, recognized also by `Bash` in `MSys2`, I
took this chance looking into the whole _symbolic link thing_ on Windows.{%
sidenote sn-not-so-well-researched As a departure from my previous practice,
i.e. conduct thorough research first and only write after I _feel_ I know enough
in a systematic way. I'll write what I've researched so far, what I decided to
use and leave the rest with a note for potential future research. In a nut
shell, I'll do it in an note-taking fashion. %}

# The Four Types

According to [Symbolic links][symlink] in the `Cygwin` website, there are
four types of _symlinks_ on Windows:

[symlink]: https://cygwin.com/cygwin-ug-net/using.html#pathnames-symlinks

## `Cygwin` default symlink

As I decided later to only use this one, I'll quote the whole passage:

> The default symlinks are plain files containing a magic cookie followed by the
> path to which the link points. They are marked with the DOS SYSTEM attribute
> so that only files with that attribute have to be read to determine whether or
> not the file is a symbolic link.

Very Linux-ish: plain text file for everything. Just open the file with an
**external** editor and you can to see everything written inside. {% sidenote
sn-external-editor External to the `Bash` in use. After all, all commands
bundled with the `Bash` are built to treat these _plain files_ as real symlinks ;P %}

## The Windows `.lnk` shortcut 

Plus some special header and DOS READONLY attribute.  

This one sounds quite appealing from the beginning. However, first there is no
native way to create `.lnk` from command line (other then the `cygwin`'s `ln`),
second you need to set `CYGWIN` to `winsymlinks`, an extra trouble that gains
nothing anyway.


## Native Windows symlinks

This has been around for quite a while now and requires file system support,
like `NTFS`.{% sidenote sn-fat32 Are there much use for FAT32 still? Linux's
support for NTFS is quite stable now. %}

This type of symlink is more a equivalence of `Linux` symlink than any other
option, however it has some weird restrictions and behaviors.

## NFS links.

Never used these, and thus I will not explore them here.{% sidenote sn-nfs `NFS`
is really convenient in a Linux-centric environment. However since I've migrated
to work on Windows, the combination of `vboxsf` share folder and `Samba` is good
enough. `vboxsf` is way easier to setup and `Samba` has sufficient performance
for now. %}

# Create fake symlink from script

As stated above, this one is the easiest to understand, the below is the core
part of a script I'm using to create such a link in `MSys2` environment:

``` shell
echo -n -e "!<symlink>$target\\x0\\xd" > "$link"

attrib.exe +S "$link"
```

1. `-e` toggle asks `echo` to interpret `\xHH` form as a byte with hexical value
   of `HH`. You need double slashes in the double quotes. {% sidenote
   sn-special-chars In this case, the two special chars at the end is `NULL` and
   carriage return (aka. `\n`, CR, Return). %}
2. `attrib` is an Windows utility since the DOS era. Here we need to set
   `System` attribute as `Cygwin` mandates. {% sidenote sn-attrib-extra The
   `attrib` allows the user to change the attribute of a file, like `Read-only`,
   `Hidden`, `System`, `Archived`. Atrributes you would see in the
   file/directory `Properties Dialog`. %}


Eventually I choose this one mainly for two reasons:

1. I use symlinks mostly from within the `Bash`, and thus interoperability with
   Windows host is a lesser concern.
2. This is so easy to understand and proved to work with `MSys2`.

# Create shortcut from CLI

Windows shortcuts are useful for `Windows Explorer` _only_. The `.lnk` file is a
binary blob that evades manual editing. What's worse there is no native CLI
tool to create such shortcuts.

During my search, I encountered a **very** interesting collection:
[NirCmd][NirCmd]. It seems to be a treasure trove of CLI utilities for various
Windows tasks, including `.lnk` creation from command prompt. I am sure to
explore it later, for now it's sufficient to point out it's not good enough to
persuade me to use `.lnk`: though well documented, `nircmd` doesn't have proper
error message if a command fails. Also it's not open source.{% sidenote sn-id
For the record, I usually do not hold grudges against non-open software. It's
just that for daily tools, I prefer to know the inner workings to be able to
tweak them to my satisfaction. Though granted, the tweaking is not done that
often ;P %}

[NirCmd]: http://www.nirsoft.net/utils/nircmd.html

# Native symlink on NTFS

The `Cygwin` documentation stated:

> Due to to their weird restrictions and behaviour, they are only created if the
> user explicitly requests creating them.

Yes, this, I couldn't agree more. 

First, it needs `SeCreateSymbolicLinkPrivilege` that is only granted to
administrator by default (sure, you can grant a user with this right simply by
... well, I can't remember those multi-step GUI-driven instructions as in this
[SO answer][SO Answer]).

Second, it has extra confusing options, as stated [here][mklink-opts]:

> You can create a hardlink (mklink /H) without admin privileges, and that will
> be executable. Hardlinks are for files, junctions are for directories,
> symlinks are for both (and /D is used to indicate that a symlink is for a
> directory)

[SO Answer]: https://superuser.com/a/125981

[mklink-opts]: https://superuser.com/a/377929

With above said, this type of symlink is still the only _true_ symlink on
Windows.


# Ending

{% marginnote mn-about-ending %}

Recently I find that I like to add these mumbling at the end of a post. It's
usually some supposedly deeper thoughts about the topic just covered. Anyway,
it's my idiosyncratic reflections that matter more to _future me_ rather than
anyone else reading the post ;P

{% endmarginnote %}


Symbolic link is conceptually simple: a location/file pointer implemented as a
file that is understood by applications. However, as demonstrated by my own
decision to use only the _cygwin fake symlink_, this understanding of
applications lies at the very root of its complexity. Understood by what
applications? By all or only some of them? What if the developers behind some
applications simply disagree with others, either due to a philosophical
difference or mere convenience? Adding all these up through _a long_ history,
together with kept, broken or semi-kept compatibility is a snapshot of any
non-trivial engineering.
