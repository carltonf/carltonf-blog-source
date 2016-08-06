---
collections: post
layout: post
date: 2016-02-06
title: Adapt other than Configure
categories: 
tags: 
- methodology
- philosophy
author: carltonf
---

After many years of unscrutinized way of *configuring* -- try to make things "the right way", I've realized that in many cases adaption is better. It offers the most smooth entry into new fields, more productivity from the very start and it's also pedagogically the best way to learn from others. Configuring still matters but only when it really matters. Stay focused, unscrutinized configuring is essentially premature optimization.


This serves as the first article written in `Markdown` directly. Previously most of my blog articles are written in `org`. I've been a long-time `org-mode` user and have done quite a bit on how to author blogs with `org`. However recently, after several attempts to fix my old configurations, I finally realized that all these struggles yield little return. 

Configure
=========
Ever since I started playing with Linux back at my sophomore year in college, I've been juggling with all kinds of configurations: configure bash, configure the wifi, configure graphical cards, the audio cards, the CPU, the fan speed, and the editor -- Emacs. I have been hooked up with the power of configuration: a lot of choices, your way, no lock-in, true understanding and etc. It used to be sweet.

However, with the time passing by, things have changed: I'm getting old; Linux desktop is just a dream; mobile computation is the future; cloud computation creates closed circles with higher and higher walls; open source is becoming a super successful **business** model; *Free Software* feels outdated and not exciting at all.

It came to my revelation that continuing the configuration path will only lead to isolation: if you prefer to install Linux only, you'll miss all the new exciting hardware that just doesn't ship with Linux driver support and you'll miss all the discounts as Linux-only devices is a niche market that doesn't enjoy the scale effect of popular consumer products. Even for the rare cases, you can theoretically get a new device to play nice with Linux, the setup can constantly get broken with updates or edge case usage and then you have to go through the search-try-and-error drill again and again. All these only for an inferior user experience that barely **works**. What's worse, the knowledge you gain by doing the chores receives diminishing return: new software and hardware are developing too fast for you to have time for deep understanding, you get to only know new terms and how to do specific stuff. Throw mobile and cloud into the mess, all become unwieldy.

Enough is enough.

Adapt
=====
All the talk on **adapting** is truly about **focus**. Maybe genius would be different, but for me, the world has become more and more complicated and time seems to be less and less. By yielding some controls, I can focus on what I can do best, a much more economical approach.

## Follow the herd ##
The following is what I've been doing recently (not an exhaustive list by any measure):

1. Bought a new-model laptop preinstalled with `Windows 10`: arguably 10 sucks and is virtually a spyware, but it's getting better fast, really *fast* and I'm not really using it for things too sensitive.
2. Bought a non-Nexus cellphone of domestic brand (Meizu) bundled with private UI and applicatioins: it's one of the best sale and thus really a bargain.
3. Install bloatware/spyware like `Weixin`, `QQ` and etc: no more preaching the merits of free protocols to my non-IT friends the next time they say: "talk to you on `Weixin`".
4. Use Windows/Android app for mails: goodbye `mu4e`, `offlineimap` and their friends. It's been good time together.
5. Use Chrome with `vimum`, less keyboard-ish but better browsing experience: goodbye `firefox`, `palemoon`, and `conkeror`(really sad to see `conkeror` go, I like it **a lot**.)
6. Learn `Powershell` to automate things on Windows: "No, thanks" for `Cygwin`, been there, tried that. And *object* shell is not that bad ;P
7. Use `hexchat` on Windows instead of `ERC`: well, `hexchat` is still a nerdy thing, but we're talking about `IRC` here ;P (PS: not that I have any complaints about `ERC`, it's just that I'm using `Emacs` within a Virtualbox VM exclusively and being a VM it constantly gets paused, saved/restored, making it less suitable for a long-going background app)
8. Linux in a VM only. This is true both for my build machine on the server and my personal working environment. It's just easier: the device driver support for Windows is almost zero-configured. With enough RAM, running a VM for coding is a valid option. I've been using this combination for half a year now. It's super. (PS: this is where I think Linux really shines: as service runner and a developer tool.)
9. Use proprietary tools like `WebStorm`, `VS Code`, `Sublime Text` instead of venerable Emacs for web development: less customization, more out-of-box integration.

Many changes happen within one or two months. I basically change half of my tools and workflow. You might think these changes would be very hard: **NO**, it's actually much easier and greatly improves my overall experience. By following the herd, I actually use mainstream tools developed&maintained by well-paid engineers and battle-tested by thousands of users. Most of the time, they just work out of the box. All I need to do is to adapt: give up some controls, learn their ways first and then see what changes we need to make, and usually you'll find their way is actually better. Yes, it's just simple like that. 

## Spacemacs ##
Weird maybe, I'll use `Spacemacs` as an example. `Spacemacs` is

> A community-driven Emacs distribution - The best editor is neither Emacs nor Vim, it's Emacs *and* Vim! 

Well, the four merits it touted on its website bear more meanings:

> Four core pillars: Mnemonic, Discoverable, Consistent and “Crowd-Configured”.

And I think `Crowd-Configured` is the jewelry on the crown. After all, you can arguably say the vanilla Emacs is also "Mnemonic, Discoverable, Consistent". Well, to be fair, I think the vanilla Emacs has too much historical baggage and far less "Mnemonic, Discoverable, Consistent" than `Spacemacs`. I've long known this starter kit and heard a lot of good things about it, but not until my recent *adapt* conviction I was too scared to use it. I've used Emacs for almost 7 years now and has accumulated my fair share of customization. Despite my inclination towards VIM's modal editing style, I've backed off from change multiple times. "How can I throw away years of hard-earned muscle memory and carefully crafted personal configurations?! What's the gain? Just to be VIM-like? Stupid!"

Encouraged by my other *adapt* successes, I started to try `Spacemacs` for a third time (yes, a third time...). "Just let it go." I told myself. "Do not think how can I do what I used to do. Think how Spacemacs handles these use cases. Learn like a newbie with an empty mind." I have my first success with `org-mode`, the killer application of Emacs IMO. I was trying to review my multi-megabytles agenda files, and navigating, state-changing, archiving, tree-manipulation are just **so** easy with `evil-org`: no more `C-M-x C-S-?` stuff which requires my fingers spread&shift like a spider's dancing. I then started to configure `mu4e`(deprecated later), `org-agenda` and `Emacs lisp`. Lisp editing proved to be the hard one: the `lisp-state` requires more modal-thinking than I'm comfortable with. However, after going through the early stage, I really start to appreciate the well-configured, discoverable functionalities: they are just there. This reminds me of my old MS Word experience: there must be a way to do this, you just need to look around and then the "Wow" moment. From this aspect, `Spacemacs` is just great. Now I can reach near previous efficiency with lisp editing now and it's just a week in `Spacemacs`. The experience has been so nice, I have switched default to `Spacemacs` before writing this article.

Conclusion
----------
I'll still *configure*, just not for everything. Only the area I focused on deserves much configuration. Other things I need? Go with mainstream, it helps. 

> Use the best tool for the task.

A well-known saying, but what many *free*-minded developers do is often: 

> If you have a hammer, you tend to see every problem as a nail.

This is particularly true for *open source* tools: hey, just read the source and happy hacking :), isn't? Now, I would say nope, there are better things to focus on.
