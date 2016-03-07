---
layout: post
title: Powershell Tips Notes
tags:
- powershell
- tips
- notes
---

Powershell tips&tricks gathered from multiple sources.

*NOTE*: this shall be an ongoing list. 


PowerShell tips for bash users - five.agency
============================================

`xargs` and for loop
--------------------

``` powershell
cat dirs | %{mkdir $_}
```


There is no `xargs` command in PS, but you can use `foreach` loop and pass the piped variable `$_` to the mkdir. Shorthand for `foreach` is `%`.

objects
-------
There is practically no way to write a script even as simple as this one without using objects.


Powershell 101 From a Linux Guy
===============================

Naming Convention
-----------------

A decent naming convention to the cmdlets, which helps in guessing... **Verb-SingularNoun**


Meta Info & Help
----------------

```powershell
$PSVersionTable

update-help

Get-Command

# measure the time
measure-command { ls -Filter "*.exe" }
```

Use object in place
-------------------

``` powershell
(ls).name

(ls).CreationTime

("hello world").Length
```

Alias
-----

``` powershell
New-Alias -Name grep -Description grep Select-String
```
