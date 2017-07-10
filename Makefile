.PHONY: default serve site-init
default: serve

PORT := 4000
CONTAINER_NAME := "carltonf-blog"
# NOTE: the backquote '`' here is equivalent to '$(shell )'
# NOTE: if you want to use a shell variable in a subshell, escape the dollar sign with `$$`
DOCKER_CMD := docker run --rm -it -v `pwd`:/srv/jekyll --user=`id -u`:`id -g`
DOCKER_IMG := carltonf/jekyll-toolbox:20170710
# NOTE the default env jekyll runs
JEKYLL_ENV := development
serve:
	@echo "** Serving content locally (at port ${PORT})..."
	@${DOCKER_CMD} --name=${CONTAINER_NAME} --label=jekyll -p ${PORT}:4000	\
			 ${DOCKER_IMG} jekyll serve --drafts --watch --incremental

build-production: JEKYLL_ENV := production
build-production:
	@echo "** Building content for publishing..."
	@${DOCKER_CMD} -e "JEKYLL_ENV=${JEKYLL_ENV}" ${DOCKER_IMG} jekyll build

### Publishing tools
SITE_REPO := git@github.com:carltonf/carltonf.github.io
site-init:
	@echo "** Init published _site/ ..."
	@git clone --single-branch ${SITE_REPO} _site

# TODO should make sure that there is existing jekyll running
site-publish: build-production
	@echo "** Quick publishing with current HEAD message..."
	@git rev-list --format=%B --max-count=1 HEAD | sed 's/^commit/source repo commit:/' \
		| (cd _site/; git add . ; git commit -F- ; git push)
