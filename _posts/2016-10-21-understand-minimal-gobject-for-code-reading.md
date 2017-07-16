---
layout: post
title: "Understand 'Just Enough' GObject For Code Reading"
date: 2016-10-18
last_modified_at: 2016-10-21
tags:
- tech
- gobject
- code-reading
- question-driven
- gnome
---

Without referring to `GObject` documentation or any online posts {% sidenote
sn-doc For the record, I can not claim I have never been exposed to `GObject`
materials. The best I can say is that I haven't *systematically* learnt
`GObject`. %}, understand *just enough* knowledge about `GObject` for the
purpose of reading related code. The process is question-driven and
code-inspired.

Reading code is essentially an activity in which readers trace the control flow
(i.e. function calls), state transitions (i.e. variable values) from *interested
points* {% sidenote sn-interested-points Say the point where an error in the log
is printed. Or `main` function, public API entries and etc. %} to a point where readers
claim *sufficient* understanding is attained {% sidenote
sn-sufficient-understanding Say points where a bug has been identified or
mis-configured environment has been confirmed. %}.

To understand `GObject` for reading code is to be able to trace method calls,
property changes. This is a problem for `GObject` because some C tricks (most
are intricate macros) are employed to implement some OOP features and they are
not at all obvious. Further, for the purpose of reading `GObject` code, I do not
need to understand how the macro magic work.

# For the Impatience

{% marginnote %}

This section was added after the main body was finished. The whole argument
below is quite lengthy and murky. Maybe it's better to summarize what I've
learnt through the process beforehand.

{% endmarginnote %}

The procedure I would form with this *just enough* `GObject` knowledge is as
follows:

Look for class hierarchical info through file dependencies (includes), and
`parent_XXX` members. Locate the exact method used in the polymorphism by
looking at explicit reference of the *real* class type, usually this happens in
the abstract, parent class. As instantiation is poorly comprehended, state
changes (updates to variable member) can be hard to track. Pay special attention
to naming, signals and callbacks. Overall, with the `OOP` experience from other
languages as direction, naming as hints, take bold `jumps of faith` to form a
*useful* understanding.


# Explain the Terms

## Question Driven

*question-driven* is to start with questions about `GObject`. Being an `OO`
implementation for C, basically we're asking about how Object-Oriented features
are achieved in `GObject`:

1. Where&How a class is defined?
2. How the class inheritance is defined?
3. What are the common implicit members?
4. How an instance is `new`-ed?
5. How `polymorphism` is implemented? (or how `this` pointer is understood.)
6. What are those `signals`?


## Code Inspired

Read `GObject` code directly and use the code snippet to figure out answers to
above questions.

In the following, I'm using code from `gnome-session-3.20.2` as example.


# Just Enough `GObject`

## Where&How a class is defined?

*Where* is relatively simple as Class is meant for reuse and thus the
declaration must be some headers.

{% marginnote %}

Technically, we should be looking at the block between `G_BEGIN_DECLS` and
`G_END_DECLS`. However these two are not helpful in identifying the class we're
interested in. Together with boilerplates like `GSM_TYPE_APP`, `GSM_APP_CLASS`
and etc., these are intuitively understood as the `GObject` *magic* and should
be skimmed over when reading the code.

{% endmarginnote %}

``` c
/**
 * SP2_GNOME_SESSION:/gnome-session/gsm-app.h
 */
typedef struct _GsmApp        GsmApp;
typedef struct _GsmAppClass   GsmAppClass;
typedef struct _GsmAppPrivate GsmAppPrivate;
```

Even from above, the verbosity of `Object` in C is obvious. `Class` and its
`Instance` have their separate types. `Data Hiding` is achieved by *explicitly*
putting internal details into a `XXXPrivate` type.

``` c
/**
 * SP2_GNOME_SESSION:/gnome-session/gsm-app.h
 */
struct _GsmApp
{
        GObject        parent;
        GsmAppPrivate *priv;
};

struct _GsmAppClass
{
        GObjectClass parent_class;

        /* signals */
        void        (*exited)       (GsmApp *app,
                                     guchar  exit_code);
        // ... more

        /* virtual methods */
        gboolean    (*impl_start)                     (GsmApp     *app,
                                                       GError    **error);
        // ... many more
        gboolean    (*impl_is_conditionally_disabled) (GsmApp     *app);
};

// ...
gboolean         gsm_app_start                          (GsmApp     *app,
                                                         GError    **error);
// ...
gboolean         gsm_app_peek_is_conditionally_disabled (GsmApp     *app);
// ...
```

As `priv` of type `GsmAppPrivate *` is only a member of `_GsmApp`, `XXXPrivate`
must be a collection of state variables for instances. The naming `parent_class`
and `parent` member has suggested that they are what *marks* the inheritance
relationship.

Two things are of more considerations: the "virtual methods" comment and
consistent naming of functions following the `_GsmAppClass` declaration.
Intuitively, I thought methods of an object are pointers to functions. Later,
we'll see it turns out that methods are mere functions with the first argument
being the object itself. {% sidenote sn-method-function Maybe this is a way to
avoid duplications. Or more importantly, it's so because of the lack of auto
`this` pointer for methods in C. Indeed, `obj->method(obj, arg1, arg2)` feels
more verbose and confusing than `type_method(obj, arg1, arg2)` as in the former
the term `obj` shows up twice. %}


## How is the class inheritance defined?

As seen above, the `parent` and `parent_class` are what define the inheritance
relationship among classes. Since the `C` has no awareness of class and
objects, there is no easy `UML` diagram to be drawn. However, by inspecting the
dependencies (include/includeby) within the source, we can still easily see
this relationship in graph as
[this diagram](/images/understand-minimal-gobject-for-code-reading/ArchInternalDependencies-gsm-app-client.png)
show. {% sidenote sn-dep-diagram Another interesting point revealed in the
diagram is the *empty* dependency from `gsm-app` to `gsm-client`, i.e.
`gsm-client.h` is included in `gsm-app.h` but nothing is used from
`gsm-client.h`. Though this might be a mere historical residual, it suggests
some connection between `client` and `app`. Indeed, `app` once started is a
`client`. (And there can be more interconnections.) %}

From the dependency graph, we see clearly that `gsm-autostart-app` is a
subclass of `gsm-app`, which is also shown in the code:

```c
/**
 * SP2_GNOME_SESSION:/gnome-session/gsm-autostart-app.h
 */
struct _GsmAutostartApp
{
        GsmApp parent;

        GsmAutostartAppPrivate *priv;
};

struct _GsmAutostartAppClass
{
        GsmAppClass parent_class;

        /* signals */
        void     (*condition_changed)  (GsmApp  *app,
                                        gboolean condition);
};
```

## What are the common implicit members?

By `implicit`, I mean members and methods created, used by the `GObject` macro
magic. They show up naturally when we trace some `GObject` functions and find
their declarations/usages are nowhere within the source tree. `XXX_init`,
`XXX_contructor`, `XXX_dispose` are most noticed ones. Though it's relatively
easy to pick these *magic elements* out, it proved to be hard to see the exact
interconnections between them.


## How an instance is `new`-ed?

{% marginnote mn-newed %}

The arguments made in this section is much less plausible than others. It turned
out to be quite hard to formalize *the guesswork* done during the analysis.
Nevertheless, to complete the project of this post, I proceeded to write out my
thoughts, with *best efforts*.

{% endmarginnote %}

The instantiation of objects turns out to be a hard procedure to get to the
exact details. Much of the difficulty stems from the mystical interactions among
implicit members. However, with some *jumps* (hypothesis), we might still be
able to to understand the code.

**First**, we notice many methods `impl_XXX` of `gsm-app` is set to `NULL`. With the
lack of `new`-ish functions, let's assume `gsm-app` is *abstract* and can not
have any instances.

**Second**, let's turn to `gsm-autostart-app`. There is `gsm_autostart_app_new`,
which seems to be the only generator of `gsm-autostart-app` externally.

```c
/**
 * SP2_GNOME_SESSION:/gnome-session/gsm-manager.c
 */
static gboolean
add_autostart_app_internal (GsmManager *manager,
                            const char *path,
                            const char *provides,
                            gboolean    is_required)
{
        GsmApp  *app;
        // ...

        app = gsm_autostart_app_new (path, &error);
        // ...
}
```

**Third**, the implementation of `gsm_autostart_app_new` looks bizarre for our
*untrained* eyes.

```c
/**
 * SP2_GNOME_SESSION:/gnome-session/gsm-autostart-app.c
 */
GsmApp *
gsm_autostart_app_new (const char *desktop_file,
                       GError    **error)
{
        return (GsmApp*) g_initable_new (GSM_TYPE_AUTOSTART_APP, NULL, error,
                                         "desktop-filename", desktop_file,
                                         NULL);
}
```

The doc on `g_initable_new` says something about
["failable object initialization"](https://developer.gnome.org/gio/stable/GInitable.html#g-initable-new).
The declaration of the function itself looks like:

```c
/**
 * https://developer.gnome.org/gio/stable/GInitable.html#g-initable-new
 */
gpointer
g_initable_new (GType object_type,
                GCancellable *cancellable,
                GError **error,
                const gchar *first_property_name,
                ...);
                
// The '...' means that the value if the first property, followed by and other
// property value pairs, and ended by NULL. 
```

The ending `varargs` of key-value pairs are of particular interests. The
following `gsm_autostart_app_initable_init` has already started to use
`desktop-filename` property.

```c
/**
 * SP2_GNOME_SESSION:/gnome-session/gsm-autostart-app.c
 */
static gboolean
gsm_autostart_app_initable_init (GInitable *initable,
                                 GCancellable *cancellable,
                                 GError  **error)
{
        GsmAutostartApp *app = GSM_AUTOSTART_APP (initable);

        g_assert (app->priv->desktop_filename != NULL);
        app->priv->app_info = g_desktop_app_info_new_from_filename (app->priv->desktop_filename);
        // ...
}
```

Where the property `desktop-filename` is installed:

```c
gsm_autostart_app_class_init (GsmAutostartAppClass *klass)
{
        GObjectClass *object_class = G_OBJECT_CLASS (klass);
        // ...

        g_object_class_install_property (object_class,
                                         PROP_DESKTOP_FILENAME,
                                         g_param_spec_string ("desktop-filename",
                                                              "Desktop filename",
                                                              "Freedesktop .desktop file",
                                                              NULL,
                                                              G_PARAM_READWRITE | G_PARAM_CONSTRUCT));
        // ...
} 
```

I've assumed `desktop-filename` is the same as `app->priv->desktop_filename`.
From these, it's reasonable to say `g_initable_new` call above is the very call
that instantializes an object.

**Finally**, Similar arguments can also be made about other parts of the
instantiation process. From the various function names and comparison with
similar functions in `gsm-app`, the *educated guess* we can have about the
instantiation process is as follows:

1. `XXX_new` is the method to *start* instantializing an object. It's likely
   there are other types of `new` offered by `GObject` other than
   `g_initable_new`.
2. `XXX_class_init` will get called if the *class data* have not
   initialized. This may happen only once as all instance share the same *class
   data*.
3. `XXX_constructor`, `XXX_init` will get called *after* `XXX_class_init`.


## How `polymorphism` is implemented?

This is already shown in previous code snippets. In short, `polymorphism` is
achieved explicitly with boilerplate code.

Take method `impl_start` as example.

```c
/**
 * SP2_GNOME_SESSION:/gnome-session/gsm-app.h
 */
struct _GsmAppClass
{
        // ...

        /* virtual methods */
        gboolean    (*impl_start)                     (GsmApp     *app,
                                                       GError    **error);
        // ...
};

// ...
gboolean         gsm_app_start                          (GsmApp     *app,
                                                         GError    **error);
// ...

/**
 * SP2_GNOME_SESSION:/gnome-session/gsm-app.c
 */
static void
gsm_app_class_init (GsmAppClass *klass)
{
        // ...

        klass->impl_start = NULL;
        // ...
}

gboolean
gsm_app_start (GsmApp  *app,
               GError **error)
{
        g_debug ("Starting app: %s", app->priv->id);
        return GSM_APP_GET_CLASS (app)->impl_start (app, error);
}
```

The definition of `gsm_app_start` shows the explicit reference to the *real*
class of `app` using `GSM_APP_GET_CLASS` macro. `gsm-app` is abstract and have
`impl_start` as `NULL`. And for `gsm-autostart-app`, it indeed sets its own
`impl_start` :

```c
/**
 * SP2_GNOME_SESSION:/gnome-session/gsm-autostart-app.c
 */
static void
gsm_autostart_app_class_init (GsmAutostartAppClass *klass)
{
        GObjectClass *object_class = G_OBJECT_CLASS (klass);
        GsmAppClass  *app_class = GSM_APP_CLASS (klass);

        // ...
        app_class->impl_start = gsm_autostart_app_start;
        // ...
}
```

So the public API for consumers of `gsm-XXX-app` is `gsm_app_start` and this can
be verified by looking up its references within the source tree.


## What are those `signals`?

This is a question we can ask only after reading the code.

From above snippets, we've seen a lot of `signal` declaration, which is not
typical among other `OOP` languages. For the purpose of understanding, most of
time they are no different than other event-driven pattern, and can be handled
as such safely. We only need to pay attention to property names, callbacks and etc,
just like the above `desktop-filename`.


# After Thoughts

While writing down the above process, I frequently doubted the usefulness of
doing them at all. Whatever the little understanding I *claim* to achieve above
is abysmal compared to what I would have *gained* in, say 2 hours of, reading
`GObject` documentation. However, I still completed the post for two reasons:

1. The *guesswork* process, inaccurate as it is, is very typical for code
   reading. And we're usually not that fortunate to have a well-polished
   documentation as that of `GObject`. Forming the *gut feelings* in the *guess*
   has proved to be arduous but fruitful.
2. The possible enlightenment I'll have when I learn `GObject` systematically.
   The reward might be some great revelation about the `guesswork` process that
   can improve my code reading skill a lot.
