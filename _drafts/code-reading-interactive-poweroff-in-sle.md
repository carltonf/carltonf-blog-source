---
layout: post
title: "Code-Reading: Interactive PowerOff in SLE"
date: 2016-10-13
last_modified_at: 2016-10-17
tags:
- code-reading
- sle
---

Powering off the computer in a Desktop sounds like an easy task from a naive
perspective. However, upon closer investigation, a single poweroff action
requires multiple independent components interacting with each other . Coupled
with security policy, poweroff is not simple at all.


This post is planned as code reading post that details the poweroff action in
SLE SP2. As components involved are standard open source components widely used
in major Linux distributions, the description here should apply in many other
distributions as well.


# Presumption

As all understanding goes, some presumptions about the readers' knowledge is
made throughout the post. I'll try to make the references few and clear.


# Components

Several components have participated in the realization of poweroff action.

## GNOME Shell

The main UI presented to the users. It mainly serves as UI server but also
integrated a polkit agent role. Roles it plays are listed below.

1. System indicator for poweroff action. Together with a system menu and
   poweroff button.
2. Poweroff/Reboot dialog. It's called `EndSessionDialog` internally.{% sidenote
   sn-endsessiondialog The direct reason for this naming is the dialog code is
   reused for logout as well. It also has more semantic meaning as
   logout/reboot/poweroff will end current session first. This session centric
   view also shows up in `gnome-session`. %}
3. [polkit-agent](https://www.freedesktop.org/software/polkit/docs/latest/polkit.8.html).
   This is **NOT** to be confused with [polkit-gnome](#), also offered by the GNOME.

## GNOME Session


## Logind


## Polkitd


## Polkit Agent

In this case, we are talking about `polkit-gnome`. Though `gnome-shell` is
playing the agent role, the analysis shall go with `polkit-gnome` to be more
general (and less confusing).


## DBus

DBus call is the means for components above to talk with each other. Both
session and system bus have a role in the overall sequence. Though relatively
transparent for callers/callees, some details of DBus can not be neglected in
the understanding of the whole flow. Furthermore, DBus imposed a timeout by
default.

# Sequence

## From Button to Dialog

## From Dialog to Authentication.

## The Timeout
