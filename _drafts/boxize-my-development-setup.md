---
layout: post
title: Boxize my development setup
---

Several months ago, I've started to redefine my development setup with
*replacable*, *standard*, *well-defined* "**boxes**": use [Vagrant](about:blank)
to manage VMs and [Docker](abou:blank) for specific development tool chain.

# Background

## The adaptionist

Not too long ago, following my adaption path. 


## The fun with VM


## The hype of container


# My setup

## Vagrant


## Docker


## Shell scripting


# Verdict

It's said "Software engineering is about complexity management" and this
engineering complexity is mainly about the *dependencies*. *modularity* is the
way to tackle complexity and a good module is a module that has clear, limited,
stable external dependencies. In this light, the *boxize* approach shares the
same merits as a good module:

- VM relies on hypervisor and OS image, both can be easily reproducible.

- Docker relies on kernel, docker engine and docker images. The first two have
  enjoyed great resource and talents investments, i.e. reliable in a human
  sense. Docker image can be easily managed, reproduced and customized based on
  existing ones.
