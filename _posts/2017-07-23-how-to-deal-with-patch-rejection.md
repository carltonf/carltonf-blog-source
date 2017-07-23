---
layout: post
title: "How to deal with Patch Rejection"
date: 2017-07-23
last_modified_at:
tags:
- tech
- patch
- script
---

When use the old good tool `patch`, rejections are commonly seen. AFAIK, the
only way to handle it properly is manual fixing. However if you are not
intimately familiar with the code base and if the difference is subtle, this
approach can become frustratingly tedious. This post explores one experiment to
try to get computer to help, i.e. scripts to identify the difference.


Despite the proliferation of `Git`, there are still occasional use of the old,
good `patch`, particularly if you need to package some software.{%
sidenote sn-Git-conflicts Rejections in `patch` are conflicts in `git rebase`,
`git merge` and etc.. The reason that conflicts in `Git` does not feel very scary
to me is that `Git` would mark the conflict in a finer, smaller chunk. `patch`
marks the whole hunk as stated in the patch as `rej` and sometimes it's too
large to be useful. %}


# The Situation

One day I was rebasing patches of some package to a new version {% sidenote
sn-id Though irrelevant for the topic at hand, for the curious, the package in
question is [openattic](https://www.openattic.org/), an open source storage
management tool. The patch in question is fixing a bug related to erroneous disk
usage reporting when `ceph` `RBD` has `fast-diff` feature enabled. %}, the
following rejection occured:

``` diff
--- backend/ceph/models.py
+++ backend/ceph/models.py
@@ -809,30 +809,34 @@ class CephRbd(NodbModel, RadosMixin):  # aka RADOS block device

     @bulk_attribute_setter(['used_size'])
     def set_disk_usage(self, objects, field_names):
-        fsid = self.pool.cluster.fsid
-        pool_name = self.pool.name
+        self.used_size = None

-        if len(TaskQueue.filter_by_definition_and_status(
-                ceph.tasks.get_rbd_performance_data(fsid, pool_name, self.name),
-                [TaskQueue.STATUS_NOT_STARTED, TaskQueue.STATUS_RUNNING])) == 0:
-            ceph.tasks.get_rbd_performance_data.delay(fsid, pool_name, self.name)
+        if 'fast-diff' in self.features:
+            fsid = self.pool.cluster.fsid
+            pool_name = self.pool.name
+
+            if len(TaskQueue.filter_by_definition_and_status(
+                    ceph.tasks.get_rbd_performance_data(fsid, pool_name, self.name),
+                    [TaskQueue.STATUS_NOT_STARTED, TaskQueue.STATUS_RUNNING])) == 0:
+                ceph.tasks.get_rbd_performance_data.delay(fsid, pool_name, self.name)

-        tasks = TaskQueue.filter_by_definition_and_status(
-            ceph.tasks.get_rbd_performance_data(fsid, pool_name, self.name),
-            [TaskQueue.STATUS_FINISHED, TaskQueue.STATUS_EXCEPTION, TaskQueue.STATUS_ABORTED])
-        tasks = list(tasks)
-        disk_usage = dict()
+            tasks = TaskQueue.filter_by_definition_and_status(
+                ceph.tasks.get_rbd_performance_data(fsid, pool_name, self.name),
+                [TaskQueue.STATUS_FINISHED, TaskQueue.STATUS_EXCEPTION, TaskQueue.STATUS_ABORTED])
+            tasks = list(tasks)
+            disk_usage = dict()

-        if len(tasks) > 0:
-            latest_task = tasks.pop()
+            if len(tasks) > 0:
+                latest_task = tasks.pop()

-            for task in tasks:
-                task.delete()
+                for task in tasks:
+                    task.delete()

-            if latest_task.status not in [TaskQueue.STATUS_EXCEPTION, TaskQueue.STATUS_ABORTED]:
-                disk_usage = latest_task.json_result
+                if latest_task.status not in [TaskQueue.STATUS_EXCEPTION, TaskQueue.STATUS_ABORTED]:
+                    disk_usage = latest_task.json_result

-        self.used_size = disk_usage['used_size'] if 'used_size' in disk_usage else 0
+            if 'used_size' in disk_usage:
+                self.used_size = disk_usage['used_size']

     def save(self, *args, **kwargs):
         """

```

And the relevant part of the current source is listed below:

``` python
    @bulk_attribute_setter(['used_size'])
    def set_disk_usage(self, objects, field_names):
        fsid = self.pool.cluster.fsid
        pool_name = self.pool.name

        if len(TaskQueue.filter_by_definition_and_status(
                ceph.tasks.get_rbd_performance_data(fsid, pool_name, self.name),
                [TaskQueue.STATUS_NOT_STARTED, TaskQueue.STATUS_RUNNING])) == 0:
            ceph.tasks.get_rbd_performance_data.delay(fsid, pool_name, self.name)

        tasks = TaskQueue.filter_by_definition_and_status(
            ceph.tasks.get_rbd_performance_data(fsid, pool_name, self.name),
            [TaskQueue.STATUS_FINISHED, TaskQueue.STATUS_EXCEPTION, TaskQueue.STATUS_ABORTED])
        tasks = list(tasks)
        disk_usage = dict()

        if len(tasks) > 0:
            latest_task = tasks.pop()

            for task in tasks:
                task.delete()

            if latest_task.status not in [TaskQueue.STATUS_EXCEPTION, TaskQueue.STATUS_ABORTED]:
                disk_usage, _exec_time = latest_task.json_result

        self.used_size = disk_usage['used_size'] if 'used_size' in disk_usage else 0

    def save(self, *args, **kwargs):
        """
```

A quick scanning can tell that the patch mainly adds a `if` test for `fast-diff`
feature and wraps the previous code into `if` block. The meaning is relatively
straightforward, the rejection difference is subtle though.


# This is NOT the first time.

Sure, the patch is not really too long, just do some meticulous comparison and I
shall snatch the difference out in no time. But, this is not the first time I
come across this type of situation and the whole
line-by-line-differencing-with-your-eyes thing is not fun at all. As the saying
goes:

> Anything done twice should be automated!

So let's think about the method for a while.


# Why the rejections

The reason behind rejections is simple: `patch` find the lines to be patched in
the current source doesn't match with those in the patch. These lines also
include context lines, who serve as important anchors in a patch. And as a tool
`patch` plays safe: _in doubt, reject_.

So here what we really need to do is extract the supposedly to-be-patched lines
and their context from the patch and do an old-fashion `diff` with the part of
the _current_ source. Easy enough, isn't it? Here are the commands to turn these
thoughts into action:

``` shell
# 1. Extract the relevant part of the source
#
# NOTE in subtle-difference case, the line range in the patch is usually accurate enough
# i.e. @@ -809,30
sed -n '809,838p' backend/ceph/models.py > cur-orig

# 2. Extract the supposedly to-be-patched lines and their context from the patch.
# NOTE original lines and context are started with minus `-` and white space ` `
# respectively, match only these lines and strip away these leading characters.
sed -n -e '/^[- ]/s/^[- ]//gp' backend/ceph/models.py.rej > rej-orig

# 3. Do an old-fashioned diff
diff -u cur-orig rej-orig
```

An important note about `-n` option of `sed`:{% sidenote sn-id _From_ the
[GNU sed manual](https://www.gnu.org/software/sed/manual/sed.txt). %}

> By default 'sed' prints all processed input (except input that has been
> modified/deleted by commands such as 'd'). Use '-n' to suppress output, and
> the 'p' command to print specific lines.


The end result is:

``` diff
--- cur-orig        2017-07-21 11:33:30.000000000 +0200
+++ rej-orig 2017-07-21 11:38:22.000000000 +0200
@@ -1,3 +1,4 @@
+-- backend/ceph/models.py

     @bulk_attribute_setter(['used_size'])
     def set_disk_usage(self, objects, field_names):
@@ -22,7 +23,7 @@
                 task.delete()

             if latest_task.status not in [TaskQueue.STATUS_EXCEPTION, TaskQueue.STATUS_ABORTED]:
-                disk_usage, _exec_time = latest_task.json_result
+                disk_usage = latest_task.json_result

         self.used_size = disk_usage['used_size'] if 'used_size' in disk_usage else 0

```

Now, it's crystal clear what _is_ the difference, the current source assigns an
extra variable `__exec_time` from the value of `lastest_task.json_result`.
Investigate the use of this new variable and change the patch accordingly. _The
Fin_


# Ending

I don't think I'll use this tech often, as the use of bare-bone `patch` is fading
into the history. However, I wrote this post to demonstrate what a little script
can do. And I also want to emphasize that it's not about how much time is saved,
if any at all in this case, but more about the proper way of thinking: the
solution is not necessarily the only goal, the process itself should be
rewarding and benefit the skill development in the long run. In this light, all
those little scripts and extra effort make perfect sense.
