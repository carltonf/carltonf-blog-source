Personal Site at [carltonf](http://carltonf.github.io)

[Blog Source](https://github.com/carltonf/carltonf-blog-source) is hosted
separately, built locally and pushed to [Blog
Site](https://github.com/carltonf/carltonf.github.io).

# Authoring&Publishing in [Blog Source](https://github.com/carltonf/carltonf-blog-source)

Some ancillary tools are supplied in `Makefile`. A standard workflow in
authoring&publishing a post is:

  ```sh
  git clone git@github.com:carltonf/carltonf-blog-source.git
  cd carltonf-blog-source/
  # clone site repo into `_site/`
  make repo-init
  # write some posts and commit into source repo

  # build the new site
  make serve
  # publish to site: no manual intervention is needed
  make site-publish
  ```
