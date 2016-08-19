---
layout: post
title: To Quote or not quote: it's a problem
last_modified_at: 2016-08-19
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
anything about the following `STRING` is optional. This leads a common mistake:

  ```sh
  if [ -n $val ]; then
    echo "1. $val is not empty"
  else if [ -n "$val" ]; then
    echo "2. $val is REALLY not empty"  
  else
    echo "3. $val is empty"
  fi
  ```

For all strings the output will be *"1. $val is not empty"*. To get right with
`test -n`, quoting is a must. This is why for testing empty string, a common
idiom is used: `[ z$val = z ]`


### The wrong number of arguments

Consider `my_awesome_func $val`, if `val="hello world"`, `my_awesome_func` will
get two arguments `hello` and `world` instead of a single string `hello world`,
which might be what we want.

### `Embedded` quotes?

`Command="sh -c" systemctl reboot ""` from recent `icewm` code.

`{{ }}` liquid example
