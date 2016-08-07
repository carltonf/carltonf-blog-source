# As Thu Aug  4 CST 2016, local Jekyll is using docker image jekyll/jekyll


.PHONY: default serve repo-init
default: serve

PORT := 4000
CONTAINER_NAME := "carltonf-blog"
DOCKER_CMD := docker run -it --rm --label=jekyll
DOCKER_IMG := carltonf/jekyll-toolbox:latest
serve:
	@echo "** Serving content locally (at port ${PORT})..."
	@${DOCKER_CMD} --name=${CONTAINER_NAME} -v `pwd`:/srv/jekyll -p ${PORT}:4000 ${DOCKER_IMG} jekyll serve

### Publishing tools
SITE_REPO := git@github.com:carltonf/carltonf.github.io
site-init:
	@echo "** Init published _site/ ..."
	@git clone --single-branch ${SITE_REPO} _site

site-publish:
	@echo "** Quick publishing with current HEAD message..."
	@git rev-list --format=%B --max-count=1 HEAD | sed 's/^commit/source repo commit:/' \
		| (cd _site/; git add . ; git commit -F- ; git push)
