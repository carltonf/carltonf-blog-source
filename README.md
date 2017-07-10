Personal Site at [carltonf](http://carltonf.github.io)

[Blog Source](https://github.com/carltonf/carltonf-blog-source) is
separated from the published site, which is built locally and pushed to [Blog
Site](https://github.com/carltonf/carltonf.github.io).

# Authoring&Publishing in Blog Source

`Makefile` have some useful subcommands and might worth taking a look. A
standard workflow in authoring&publishing a post is:

  ```sh
  git clone git@github.com:carltonf/carltonf-blog-source.git
  cd carltonf-blog-source/
  # clone published site repo into `_site/`
  make site-init
  # write some posts and commit into source repo
  # ... with help from tools/ ...
  # build the new site
  make serve
  # publish to site: no manual intervention is needed
  make site-publish
  ```

# Notes on Ancillary tools

## carltonf/jekyll-toolbox
My own modified jeyll image for building personal blogs. `Make` subcommands `serve` and
`site-build` use it.

The current version is 20160808, published at
[Docker Hub](https://hub.docker.com/r/carltonf/jekyll-toolbox/) and
Dockerfile is available at
[Github](https://github.com/carltonf/dockerfiles/tree/master/jekyll-toolbox).

## habit (_WIP_)
Part of the `tools/envsetup.fish`, a tool to enforce writing style.

Currently I am working on some **simple** `Bash` script to get the core function
work again.

### Never-finished fish version ###

Due to the over-engineering of the previous tool, the 2nd time I try to rewrite
them in `fish` scripts. It was a good experience at the beginning, but the fact
that I seldom got the chance to write `fish` scripts makes all gains from `fish`
itself lost. Abandoned.

### Initial Nodejs version

The core functionality was actually working.

However, it lacks polishing and hard to maintain in the long run. Source is
hosted at [Github](https://github.com/carltonf/habit).
