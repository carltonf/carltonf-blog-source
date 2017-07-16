Personal Site at [carltonf](http://carltonf.github.io)

[Blog Source](https://github.com/carltonf/carltonf-blog-source) is
separated from the published site, which is built locally and pushed to [Blog
Site](https://github.com/carltonf/carltonf.github.io).

# Authoring&Publishing in Blog Source

A standard workflow in authoring&publishing a post is:

  ```sh
  git clone https://github.com/carltonf/carltonf-blog-source.git
  cd carltonf-blog-source/
  # setup the environment (supports bash and fish) and the tool habit
  source tools/envsetup.bash
  # [optional] clone published site repo into `_site/`
  habit init
  # write some posts and commit into source repo
  # habit new-draft
  habit commit
  # review the post with local webserver
  habit serve
  # satisfied? Publish!
  habit site-publish
  ```

# Notes on Ancillary tools

## carltonf/jekyll-toolbox
My own modified jeyll image for building personal blogs. Many of `habit`
subcommands use it.

The current version is 20170710, published at
[Docker Hub](https://hub.docker.com/r/carltonf/jekyll-toolbox/) and
Dockerfile is available at
[Github](https://github.com/carltonf/dockerfiles/tree/master/jekyll-toolbox).

## habit

The main tool used for authoring and publishing, a part of the
`tools/envsetup.*sh`.

Currently it's implemented in Bash. The below is a short history of this tool ;P


### Never-finished fish version ###

Due to the over-engineering of the previous tool, the 2nd time I try to rewrite
them in `fish` scripts. It was a good experience at the beginning, but the fact
that I seldom got the chance to write `fish` scripts makes all gains from `fish`
itself lost. Abandoned.

### Initial Nodejs version

The core functionality was actually working.

However, it lacks polishing and hard to maintain in the long run. Source is
hosted at [Github](https://github.com/carltonf/habit).
