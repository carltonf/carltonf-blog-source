---
collections: post
layout: post
date: 2015-07-10 Fri 16:18
title: A workflow for bug fixing
categories:
tags:
- tech
- bug-fix
- workflow
author: carltonf
---

As a developer in SUSE Desktop Department, most of my work are bug fixing. Desktop bugs are diversified in nature: you constantly need to handle bugs from an unknown package or some esoteric features. To comb with this reality, I've been pondering on the proper methodology. 

{% marginnote about-diversity %}
About the diversities, here is a rhetoric saying with the *[80-20 principle](https://en.wikipedia.org/wiki/Pareto_principle)*: **80% of the time we work with only 20% of the knowledge we need**.
{% endmarginnote %}

**DISCLAIM:** *this post has undergone some format conversions and the current formatting quality is not very good.*

1.  You want to learn! And not timid before the unknown.

2.  SRN: Search, Read, Note and repeat.

    One of my main complaints about my last job in a local company is that they have regulated web access excessively in the office: in order to search for information I have to use common terminals that are constantly in short. IMO, this restriction contributes as half to the failure of the new project as all other factors combined. From that time on, I decide that I should refuse to work on any new project without decent web access.

    Document reading is a trait that I believe many interviewers have overlooked (at least no one ever asks me about this part). In today's fast-paced world, technology evolves quickly. Reading is the best way to keep in sync with the new developments.

    Noting is more about recording what you've found. You need to mark what info you think are more important, more relevant, what questions or unclear points you still have. For this purpose, pen&paper is always my favorite.

3.  A logical workflow.

    The first two steps help you become comfortable with a new package or field. After you've been briefed with the context and you need to handle the problem itself. The reality is we still know only very little so the previous steps tend to appear again and again.

My workflow
===========

In short: **problem -&gt; questions -&gt; solutions -&gt; actions**

1.  Divide and rephrase the **Problem**.

    Bug reports from customers or QA are never the appropriate way you should think about the bugs. Reproduce the bugs, be creative, try out different cases. Play with the problem till you can divide/rephrase the problem in a way you're confident it can be addressed technically.

2.  Ask Questions.

    What is this? Why something work in A situation but not B? How the other program handle this situation? What if I do this?

    Whatever the question you ask or encounter. Do the SRN.

3.  Make the bold assumptions and leave questions unanswered.

    A careful mind will always have more questions than what it can manage to answer in the limited period. Keep in mind the goal is fixing bugs, and questions can be dealt with by: **making bold assumptions** if all known facts fit, **unanswered** if not considered relevant, **short answer** if that's sufficient.

    I've always found **assumption** is a very effective way of moving things forward. A striking fact is human minds work similarly: many times what you think intuitively is not too far away from what others've done. As long as the exact detail is not needed, by making assumptions, we save us time and progress fast. (And there is little to lose, correct it if we assumed wrong.)

4.  Iteration till a solution comes to your mind.

    There are no recipes for locating the solution. It comes to you at proper time ;P after enough work along the right direction.

A workflow example
==================

The rest of the article is a workflow document I've created while fixing a Desktop bug. It's a reproduction as in work I actually only sketch on paper. I also would not include any references on the details because the outline is more important for ideas I'd like to share.

------------------------------------------------------------------------

**Example**

Related the component is in `SLE Classic` `extension.js` part.

Rephrasing
----------

As in my comment \#3, the main issue is the misuse of GNOME Tweak tools.

Two real bugs remain:
1.  Window buttons are not shown or displayed correctly across workspace.
2.  Nautilus has issue dealing with window grouping.

Workflow
--------

### FACTS & Questions

#### DONE How windows add&remove event gets detected?

`this._workspaceSignals` a hash map holds `window-added` and `window-removed` listeners IDs.

The listeners are working as expected.

#### \*FACT\* The grouping works correctly in one single workspace.

##### DONE **Q**: How? And can we duplicate the logic to multiple workspaces?

`_populateWindowList` has check on the grouping setting. If the grouping is turned on, `AppButton` is used, o/w `WindowButton` is employed.

###### DONE **Q** Why only windows in current WS is displayed? (no grouping for simplicity.)

`WindowList` holds all window/app buttons. Each button is responsible for checking whether it should be displayed with regards to current workspace.

**App and Window Button have different visibility criteria**. More on this later.

###### **FACTS** `AppButton` is new to me.

Two implications only happens to me later: bugs that were fixed for `WindowButton` should be ported to `AppButton`. `AppButton` and `WindowButton` are similar in nature but do **NOT** share a same class hierarchy, which I believe is an issue.

####### TODO Should `AppButton` and `WindowButton` has a same parent?

To prevent duplicated code and emphasize the common role both play.

#### DONE **Q**: Why switching back&forth workspaces fixes button issues?

1.  `_populateWindowList` recreate all active window/app buttons, but this routine only run at `notify::allocation`, which is **NOT** triggered with workspace change.

2.  `AppButton` is similar to `WindowButton`, visibility check callback is hooked to `switch-workspace` signal.

    This finding leads necessarily to the first solution.

### Solution: missing or legacy buttons.

#### TARGET: `_onWindowAdded`, `grouped` branch.

Add `AppButton` visibility update callback into `windows-change` signal from `ShellApp`.

#### Fixes

-   No button in new workspace if we open a new window for an already running application.
-   Remaining legacy button in a workspace after all windows of one application is closed. NOTE, the application is still running, i.e. it has opened window in some other workspace.

### Solution: Title problem

#### **FACTS**

-   Currently button title only gets updated with "windows-change"
-   \[ \] "windows-change" is signaled even only by switching workspace

    This explains why switching fixes some issues. But why this event gets triggered?

#### TARGET: `_windowsChanged`

There is a bug in original code. It doesn't consider the case when an application has two single window in separate workspace as it does nothing if `this._windowTitle` exists. Forcing update to fix this.

#### Fix

-   Incorrectly displayed title, see original bug report for detail.

### DONE Q: an app gets its window list on current workspace? Specifically for `Nautilus`.

`_getWindowList` uses API `Shell_app_get_windows`, which returns **all** windows belonging to a specific application.

`win.located_on_workspace(ws)` is used to check whether `win` is in `ws`.

### Solution: Desktop is shown as a window in the panel with grouping on.

-   `_getWindowList` should only check window types. Only return window of type `Meta.WindowType.NORMAL`.

#### DONE Q: Why an `Nautilus` button is still displayed even without `Desktop`.

`_updateVisibility` uses API `Shell_app_is_on_workspace` (`shell-app.c`), which according to [this patch](https://mail.gnome.org/archives/commits-list/2011-January/msg04214.html), will return `true` for Desktop window (a workspace less window as we see).

#### Sol

Use `(this._getWindowList() > 0)` to test for visibility.

This is safe as `shell_app_is_on_workspace` uses the same logic. The only difference is application in STARTING status and workspaceless window, both should be ignored anyway.

### **FACT:** If `grouping` is enabled, context menu is shaky and unusable, also a lot of stability issue.

-   \[X\] "button-press-event" issue
-   \[X\] `this._contextMenuManager` should remove `this._appContextMenu` if there is a single application window.

Final Report
------------

A patch has been submitted.

Both issues for demonstration 1 and nautilus have been fixed for **SLE Classic**.

In short the original code contains multiple grouping bugs.

Details: In total 4 separate bugs are identified and addressed.
1.  Failure to update buttons visibility when windows are added/removed for an application.
2.  Window title is not updated correctly.
3.  When deciding what windows should be displayed as buttons, failed to exclude abnormal windows like Nautilus Desktop.
4.  (Found in Development) Forget to manage <sub>appContextMenu</sub>, which, with grouping on, leads to instability and focus grabbing issue for button context menu

Further, I've overlooked AppButton in previous fix. So some patches for WindowButton is also ported to AppButton.

∎ **Example End**
