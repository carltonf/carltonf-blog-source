---
layout: post
title: Writing habit and tools
date: 2016-08-21
last_modified_at: 2016-08-29
---

As a follow up to my [TODO review](/post/revisiting-todo-of-this-site), I've
rolled out the first draft of a writing habit, together with an over-enginered
tool, [habit](https://github.com/carltonf/habit), to enforce it.


# The Life Cycle of a Post

The life cycle of a post {% sidenote sn-life-cycle A nerdy term, more plainly,
the steps for writing posts. ;P %} is the sequence of stages and states a post
will undergo through. I've devised two stages each with its own set of states:
{% sidenote sn-s-naming In retrospect, the naming is a little bit too mouthful and I
might change them later. The reason behind all these *present tense* is my
(clumsy?) attempt to emphasize the dynamic, continuous nature of each phase. %}

- draft: scaffolding, fledging, editing.
- post: polishing, reviewing


## Goals of Topic

In consistence with my view of
[post as idea-observational diary](/post/revisiting-todo-of-this-site#the-philosophy-collection),
the transition between stages and states are not strictly defined. In fact, I
would rather like free-style transitions among them. Posts represent the idea,
as ideas evolve so should posts.


## Draft

Influenced by the [`Jekyll`'s way](https://jekyllrb.com/docs/drafts/) of
organizing posts, `draft` is simply a stage when posts are not deemed as befit
publishing.


### Scaffolding

This may sound like just a fancy way to say *outline*, but by using a different
word I try to emphasize the importance of *goal*-setting. Just like building
scaffold, once erected, the building is constructed as such. The later editing
should not stray too far away from the initial goal {% sidenote
sn-programmers-straying Maybe it's not only my own bad habit, all programmers
may like to do something *smarter*, *better* or *more*. The end result is
usually *over-engineering*, *pre-mature optimization* and *unmet deadline*.
Sigh... %}.


### Fledging

At this state, I am conducting research and gathering raw materials for the post
in work. Throughout the years, I've learned the importance of extensive
references and citation. They are not merely there to make the work look more
professional, but to support the post, establish connections among different
knowledge bits and mostly importantly make the post **maintainable**.

**Connections:** In an age of fast searching and ubiquitous access to Internet,
memorizing exact details is usually not worth the effort. It's more important to
construct a mind map holding references to details.

**Maintainable:** You might not even remember you write this post a year ago.
How do I reach this conclusion? Why do I say that? I read some of my diaries in
high school and shocked by what I've written {% sidenote sn-diary I am shocked
by the beautiful and sensational sentences (in Chinese for sure) in my old
diaries. I know I'll never be able to write something like that. Sigh, I used to
be a sensitive youth and now I'm just "old and mean". %}. I used to think the
extensive references following the article are only for research papers. Now I
believe they are necessary for anyone who takes their thoughts serious. It's
essential to make long-term post reviewing possible.


### Editing

A large potion of the work in this state is about formating. However, I'll
remind myself this state is more about the style: remove all unnecessary parts,
check all references, check the spell, make the main body focused and move all
smartness to side notes.


## Post

A post enters this stage when it's published. There several guidelines I'll try
to follow:

1. *publish early, publish often* {% sidenote sn-early-often A derivative from
   the famous
   [Release early, release often](https://en.wikipedia.org/wiki/Release_early,_release_often).
   In my search, [Leanpub](https://leanpub.com/), an ebook-publishing platform
   has used it. %}: this principle is particularly important. Whenever a post
   takes too long to publish, it's a time to think whether the original goal is
   too big and it'd better be divided into multiple smaller posts.
2. Though rare, it's **OK** to transition back to draft. In such a case, a
   question should also be asked whether it's better to write a follow up post.


### Polishing

Typos, ill-formatted text, wrong references, extra style tweakings and other
non-content-modifying changes.


### Reviewing

The changes that modify the content belong to this state. The *maintainability*
 of the post will be very important at this state. Just like code, posts are
 works of thoughts, in the long run, it's the maintenance that costs the most.


# Tool Enforcement

I've written a tool in `node` called [habit](https://github.com/carltonf/habit)
to enforce the stages and states above {% sidenote sn-tool-naming For now it's a
tool only for writing post, but I have the intention to grow it into a habit
enforcer. `node` is picked as I'm most familiar with it and shell scripts are
not good for long-term growth. For the record, I indeed
[implemented](https://github.com/carltonf/carltonf-blog-source/commit/a245ebc6687cef69b914d76a46cddc87b43a2f95)
some functions of `habit` in `fish` shell script before migrated to `habit`. %}


## How the tool enforce the habit

Check out the [README](https://github.com/carltonf/habit) for details. It
suffices to say `habit` helps the author focus on a single post;
unify, provision and validate `Git` commit message to track stages and states;
manage posts' meta data, draft creation and post publishing {%
sidenote sn-creation-publishing At the time of writing, these are just plans.
[Jekyll-compose](https://github.com/jekyll/jekyll-compose) is not sufficient for
our needs. %}.

Over-engineered? Yes for now, but it's better to have a tool to remember for us
than rely on forgetting human mind.


## The design&implementation - CLI in Node

See [CLI tool development wiht nodejs - an example](#) {% sidenote sn-cli-node Planned. %}
