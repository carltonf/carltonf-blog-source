LOCAL_SERVER_ADDR := 192.168.56.101
EXTRA_ARGS := --drafts --incremental --watch

serve:
	@echo "** Serveing content locally..."
	bundle exec jekyll serve ${EXTRA_ARGS} --host ${LOCAL_SERVER_ADDR}

update:
	@echo "** Update dependencies..."
	bundle update
	bower update
