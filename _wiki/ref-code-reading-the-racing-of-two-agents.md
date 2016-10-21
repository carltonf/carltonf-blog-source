---
collections: wiki
layout: post
title: "Ref: Code-Reading: The Racing Of Two Agents"
date: 2016-10-18
last_modified_at: 2016-10-18
tags:
- ref
- code-reading
---

# Required Apps

``` c
/**
 * SP2_GNOME_SESSION:/gnome-session/gsm-session-fill.c
 */
find_valid_session_keyfile (const char *session)
{
  // ...
  /* NOTE: multiple places are looked up for session file */
  dirs = g_ptr_array_new ();
  // ...
  /* NOTE: about XDG_DATA_DIRS, which is '/usr/share' on current system. */
  system_data_dirs = g_get_system_data_dirs ();
  for (i = 0; system_data_dirs[i]; i++)
    g_ptr_array_add (dirs, (gpointer) system_data_dirs[i]);
  // ...
  basename = g_strdup_printf ("%s.session", session);
  // ...
  for (i = 0; i < dirs->len; i++) {
    /* NOTE: /usr/share/gnome-session/sessions/ */
    path = g_build_filename (dirs->pdata[i], "gnome-session", "sessions", basename, NULL);
    keyfile = get_session_keyfile_if_valid (path);
    // ...
  }
  // ...
  return keyfile;
}
```

``` ini
# NOTE: SP2_GNOME_SESSION:/data/gnome.session.desktop.in.in
[GNOME Session]
_Name=GNOME
# NOTE: Required Apps
RequiredComponents=org.gnome.Shell;gnome-settings-daemon;
```

``` c
/**
 * SP2_GNOME_SESSION:/gnome-session/gsm-session-fill.c
 */
static void
handle_required_components (GKeyFile               *keyfile,
                            gboolean                look_in_saved_session,
                            GsmFillHandleComponent  callback,
                            gpointer                user_data)
{
        char **required_components;
        // ...
        required_components = g_key_file_get_string_list (keyfile,
                                                          GSM_KEYFILE_SESSION_GROUP,
                                                          GSM_KEYFILE_REQUIRED_COMPONENTS_KEY,
                                                          NULL, NULL);
        // ...
}
```
