---
layout: post
title: Still Emacs, still Tufte
date: 2017-07-10
last_modified_at: 2017-07-10
tags:
- markdown
- tufte
- emacs
- writing 
---

Quite long ago, I started to use `Tufte` style for my blog posts. The liquid
tags used is from `Immaculate`. As with all plain-text formatting, these tags
eventually get in the way.{% sidenote sn-tufte-tags From Word-like WISIWIG to
plain-text formats like the venerated `Tex` or much simpler ones `Markdown` or
`Org-mode`, the key differences are **whether** the formatting tags are seen and
**how demanding** the formatting requirement is. The formatting requirement of
`Tufte` style is more demanding than conventional markdown documents and thus
the tags feel more cluttering. %} As a weekend project, I hacked a
`markdown-tufte` extension for `Emacs`. It help me cope with the
sidenote/marginnote _mess_.

![screenshot](/images/still-emacs-still-tufte/markdown-tufte-screenshot.png)

The above is the screenshot for the extension. You can find the code at
[markdown-tufte][markdown-tufte].

[markdown-tufte]: #
 
And the rest of this post are some thoughts (murmuring).

# The question of writing too little

Often as it is, my thoughts upon why I've written so little did myself no good.
Nevertheless, this is still what I did in the last weekend.

I thought that I was busy, that I was learning too many things in the meantime,
that I did not really write nothing as there are some unfinished drafts laying
around, that I was lazy and undisciplined, that the tool chain was too
complicated.

All these _excuses_ have some truth in it. And I started with the tool chain -
the concrete one. {% sidenote sn-excuses Yes, more disciplines about writing
have been written down and I shall carry them out by the words! Well, at least
so I claimed ;P %}

## The quest for better tool.

The old `habit` tool was over-engineered and are being converted to simple bash
script. But for the weekend, I looked at the editor and the environment with/under
which I author and publish.

Here are the requirements for the editor:

- vim-like keybinding: unrivalled for smooth _English_ post editing. {% sidenote
  sn-english-editing Maybe all alphabetical languages share similar features.
  Emacs are not that good at Chinese as word-level navigation is useless for
  Chinese. %}
- Support Tufte style.
- Almost all platform, at least `Windows` and `Linux`
- Markdown, better with live preview. {% sidenote sn-live-preview I have doubts
  over the usefulness of live preview: they seem to be only useful, when one is
  new to the syntax of `Markdown`, and it's a great source of distraction. %}


### `Visual Studio Code`

{% marginnote mn-vscode %}

Behind the scene `VSCode` uses the same technology as `Atom` editor, and I like
Web technology pioneered by `HTML5` and `ES6_`. To me, `VSCode` is the best
offer from `Microsoft` to the open source community (other than `WLS`, Windows
Linux Subsystem, maybe, if `WLS` is more stable and has less edge corners.)

{% endmarginnote %}

Well, if some day I do not use `Emacs` any more, this would be my number 1
choice. Other than `Tufte` support, it has everything I want. And it might just
take a few days hacking to put together an extension to add support for `Tufte`
anyway.

The problem is, for post writing, it doesn't beat `Emacs` and I know one thing
or two about how to write `ELisp`, a plus for Emacs. If I need to do
some Web hacking, particularly in `TypeScript`/`JavaScript`, it would be my
choice.

### `RMarkdown`

A flavour of `Markdown` from `RStudio`. Among all other features, this one
supports `Tufte` style.

It's just that `RStudio` is a beast and I am not doing any data science, yet.
Also I only used `RStudio` once before to learn some basics about `R` and it was
quite a while ago. The learning cost would be too high just for the posts.


## About Habit and Discipline

My previous English teacher Alex {% sidenote sn-alex Just two weeks ago, we had
the last class. He is a funny guy. His class makes you feel like a group of
young folks chitchatting together, sharing childhood stories and small, funny
quarrels with his Chinese girlfriend. %} said he forced himself to write
something in the early morning to form a habit of writing. Anything, anything
will do, even lines like _"I do not know why I am sitting here, I do not have
anything to write, and I just forced myself to do so. Oh, I just finish brushing
my teech and blabla"_. And by this method, as he claimed, he manages to finish
writing a book about his 4-year stay in China.

I should learn something from this.

## Less Discipline

While writing this post, I noticed what a bliss it is not to try to get
reference for everything. I [wrote once][refs] before that references are
important. I still believe so, but the extra work for references might as well
cost my writing productivity. As thus the benefits do not justify the cost.
**Let's only make important references for important posts**. And along this
line we should relax some of the rules I laid before about writing to encourage
writing more.

[refs]: /writing-habit-and-tools#fledging

# Ending

Well, this post also serves as a test ground for the `markdown-tufte` extension,
so far so good. Happy posting now ;)
