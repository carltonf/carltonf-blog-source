---
collections: post
layout: post
title: Revisiting TODO of this site
date: 2016-08-06
tags:
- tech
- todo
- admin
author: carltonf
---

With a revamping done, it's a good moment to reflect upon the old plan I had for
this site and some ideas about it in the future.

It's been quite a while since the last time I've published a post {% sidenote
sn-drafts for the record, I *did* write several drafts during this vacancy %}
and now this site is undergoing a second redesign. {% sidenote sn-history The
1st attempt is using [Octopress](http://octopress.org/), the 2nd attempt is
using [Org2Jekyll](https://github.com/ardumont/org2jekyll) and Jekyll itself.
There is also a 2.5 attempt when I switch from org source to markdown, but old
posts are not all converted though. %}.


# Review

The old *TODO* page was published almost exactly one year ago. {% sidenote sn-last-TODO The
last [todo note](http://carltonf.github.io/post/old-todo-page) is taken at 03
August 2015. %} The timing is a pleasant coincidence.


## Populate Wiki

I would call this part partially done as dozens of entries have been added since
then. However there are not as many as I'd like. However, at present I believe
a completely independent wiki is not necessary. Much like the value of
sidenote/marginnote, wiki should serve posts as reference source, and thus many
features planned for wikis are scratched.


## Sidebar

Sidebar is removed all together. {% sidenote sn-sidebar To my slight
surprise, half of the original *TODO* is about features for sidebar. I guess
it's because I was learning web design back then and sidebar offered the most
challenging problems. Unfortunately, these *challenges* served only as
distractions to making a good personal site: writing high-quality posts and
showcase real work. %}

Firstly, the design style of this site is [KISS](https://en.wikipedia.org/wiki/KISS_principle). 
{% sidenote sn-kiss 
In retrospect, all previous revamping are actually moving towards the current
`KISS` style. `Octopress` is full of conventions I didn't understand. Writing
posts in Emacs `org` and then do the conversion adds extra indirections and
complexities.
%}

Further, I've realized that **the most common** way visitors (including myself)
use this site is: search the web or follow some links to a post in this site,
read the interesting bits and then leave. In the very few occasions a visitor
might be curious enough to explore other parts of the site. So the pivotal point
in design should be to maximize the readability of **the post** and sidebar is
only a distraction. {% sidenote sn-sidebar Actually in the old design, sidebar
is an example of *premature optimization*. Sidebar essentially is an
optimization for site navigation, which as any other shortcut/optimization
should be justified first. It can be easily justified for some e-commerce site,
but not really for a small personal site. %}


## The Philosophy Collection

Not much have been done. However, I started to write some posts on more
abstract topics like [bug fixing
methodology](http://carltonf.github.io/post/a-workflow-for-bug-fixing), [the
merits of adaption](http://carltonf.github.io/post/adapt-vs-configure) and etc.
I think this is a good direction and in line with my aforementioned plan for
wikis. I see posts more as observational diary about ideas. It's about the
process that an idea comes into being, goes through stages of developing,
absorbing new facts, integrating with other ideas to form a system and
eventually fading into irrelevance and being superseded by new ideas. 
{% marginnote mn-idea-tips %} And it's in this view of posts, specific, reusable
tips/scripts should be factored out into wiki. Wiki serves posts (in extension
*ideas*) as references. {% endmarginnote %}

With the above said, I'll strive to stay pragmatic though ;P.


## Conclusion

That's about the review. It's a little disappointed to see only so few has been
planned.


# The *NEW* Plan

*"Nothing is ever new. Only the history previously unknown."* {%
sidenote sn-nothing-new I failed to find this saying's origin, the
closest source seems to be *"There is nothing new under the sun. It has all
been done before"* from [A Study in
Scarlet](https://en.wikipedia.org/wiki/A_Study_in_Scarlet) %}. So the *NEW*
plan is more about the ideas I've long had and would like to see implemented in
the site. The *TODO* page is no longer there, but I've enjoyed the one-year
review of my previous *TODO*.

## Style&Design

{% marginnote mn-kiss-elegance %} In my metaphor, `KISS` is like straight parallel
lines and `Tufte CSS` adds musical notes on them. {% endmarginnote %}

I've liked the [Tufte CSS Style](https://edwardtufte.github.io/tufte-css/) from
the very beginning, before I even knew its name. It's `KISS` plus delicacy. I've
adapted this style with `Jekyll` using good work done by
[Immaculate Jekyll Theme](https://cdn.ampproject.org/c/siawyoung.com/immaculate/),
which also features the
[AMP](https://www.ampproject.org/docs/get_started/about-amp.html). {% sidenote
sn-amp Personally, I know little about `AMP`, other than it's proponed by
*Google* and good for mobile devices. It seems to embed all stylesheet within
the HTML itself, which is bewildering to me for now. %}

I've also put up a homepage instead of the list of posts as I envision this site
to be the main hub for all my online activities.


## Habit

One main goal of the plan is to cultivate a habit of frequent writing. How
exactly I am going to achieve this still eludes me. Here is the sketch of what
I want to accomplish:

1. Write everyday.

   I've started using `OneNote` for planning and note taking. The accumulated
   notes can serve as a good basis. {% marginnote mn-old-notes %} Many more old
   notes are in `org` files. {% endmarginnote %} As posting everyday would be quite
   laborious, there have to be some guidelines on what to write, how to write. A
   transitory guide is to *single out an idea, quickly scratch a post and
   publish, then review and refine*.

2. Formalize a writing style.

   {% marginnote mn-todo-writing-style %} *TODO* Reflect on the way posts are
   written and put up a post about a good style {% endmarginnote %}

   Everyone has a style but not everyone is aware, let alone formalizing it. A
   consistent and formal style can really speed up writing and it's the key in
   forming the habit.


## Extra Collections

Other than the habit, I'd like to see some new additions to my site.


### Presentations

If posts are for a single visitor{% sidenote sn-posts-for To digest the content
in one's own pace. %}, presentations are for a group of audience. The format
and use cases of presentations enforces the following properties: *compact*,
*succinct*, *open for questions and critics*. It can serve as the best way to
introduce/summarize a complex topic.

As it said, *"Every job is a sales job."*. Being good at presentation also
makes one more competitive in job market.

The plan is to recap, recollect all my old presentations first. Reedit them if
the topics are still relevant today. Write new presentations whenever it's good
to do so.


### Showcases

Hmm, this part is the `default` clause in my plan{% sidenote sn-default-clause
I.e. everything else. ;P %}. More concretely, as there are some other sites
I've frequently used out there, collect those worthy ones and make a page for
them in this site. {% sidenote sn-main-hub-reiterate **This** site is my online
hut(hub). %}


### About Reading Notes

Reading notes will be removed and only more thoughtful review for books are
worth a post.

I've got some posts {% sidenote sn-reading-draft Some more are in `_drafts/` %}
that are merely quotes from books I've read. Posts are ill-fit for quote
collection like that. For the purpose of reviewing, I've found
[Anki](http://ankisrs.net/) to be handy.


## The End

That's all for now. Big ideas and let's make sure they would end up as *Big
words* only. {% sidenote sn-big-words [*"Words are
wind~"*](http://www.thefrisky.com/2012-05-16/12-words-and-phrases-from-game-of-thrones-that-need-to-be-part-of-your-vocabulary/)
%}
