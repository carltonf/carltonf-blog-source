---
layout: post
title: "To Quote or not quote - it's a problem"
date: 2016-08-21
last_modified_at: 2016-08-21
---

After writing several bash and fish scripts, we've constantly encountered some
idiosyncracies of shell scripting. One of the major headache is the the quoting.

# Quoting

What quotes usually means.

# Interactivity and Reader

String type is the first-class type and it's usually the default one.

## How various shell read input

### The descriptive explanation

### What the code reveals.

## An example from Emacs

In particular, the Emacs RegExp.


# Common pitfalls related to quotes

### `test -n`

`test -n` or `[ -n ]` will **return true**, despite the document doesn't say
anything about the argument `STRING` is optional. This leads to a common
mistake:

```sh

if [ -n $val ]; then
  echo '1. $val is not empty'
else if [ -n "$val" ]; then
  echo '2. $val is REALLY not empty'  
else
  echo '3. $val is empty'
fi

```

For all input values, the output will be `"1. $val is not empty"`. To get right
with `test -n`, quoting is a must. This is why for testing empty string, a
common idiom is used: `[ z"$val" = z ]`, and even in this case, it's better to
quote the var.

### Makefile Pass Env var to sub-Shell

Consider the following Makefile snippet: {% sidenote sn-jekyll-env This snippet
comes from my
[attempt](https://github.com/carltonf/carltonf-blog-source/commit/fd6260318210035bdc3ec3082140c5e0296b0358)
to set up a production build target.
Also see
[here](https://jekyllrb.com/docs/configuration/#specifying-a-jekyll-environment-at-build-time) if you are curious about the meaning of `JEKYLL_ENV`. %}

```make

JEKYLL_ENV := 'production'

build:
	@${DOCKER_RUN} -e "JEKYLL_ENV=${JEKYLL_ENV}" \
		jekyll:latest jekyll build

```

The above Makefile snippet is trying to pass `JEKYLL_ENV` to `jekyll` command
in docker. However, it will not work as intended. The problem is that `Make`
will not evaluate quoted string and strip the outermost quotes, instead anything
after assignment operator will be read verbatim. {% sidenote sn-make-assign
There are other complexities, like expansion and when&how the expansion is
done. See [this answer](http://stackoverflow.com/a/448939) for a simplistic yet
helpful explanation. Nevertheless, these do not affect the understanding for
this snippet. %} So the value of `JEKYLL_ENV` as seen by `jekyll` will *NOT* be
`production` but `'production'`, which of course will not have expected effect.


### The wrong number of arguments

Consider `my_awesome_func $val`, if `val="hello world"`, `my_awesome_func` will
get two arguments `hello` and `world` instead of a single string `hello world`,
which might be what we want.

### `Embedded` quotes?

`Command="sh -c" systemctl reboot ""` from recent `icewm` code.

liquid example template example
