# As Thu Aug  4 CST 2016, local Jekyll is using docker image jekyll/jekyll


.PHONY: default serve
default: serve

PORT := 4000
CONTAINER_NAME := "carltonf-blog" 
serve:
	@echo "** Serving content locally (at port ${PORT})..."
	@docker run -it --rm --label=jekyll --name=${CONTAINER_NAME} -v `pwd`:/srv/jekyll -p ${PORT}:4000 jekyll/jekyll

