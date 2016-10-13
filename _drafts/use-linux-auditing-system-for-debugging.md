---
layout: post
title: "Use Linux Auditing System for Debugging"
date: 2016-09-22
last_modified_at: 2016-10-13
tags:
- suse
- audit
- linux
---

The `Linux Auditing System` provides
[a way to track security-relevant information on your system](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Security_Guide/chap-system_auditing.html).
As debugging is also about *collecting information* for the issue, auditing
tools have proved to be a very useful info source. Unfortunately, it's been
overlooked for a long time by devs. This post highlights its prowess with
concrete examples.

# Introduction

