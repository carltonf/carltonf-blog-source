LOCAL_SERVER_ADDR := 192.168.56.101
# NOTE --incremental might not add new drafts or posts (even with restarts),
# disable it as the efficiency is not really needed for now.
EXTRA_ARGS := --drafts --watch

serve:
	@echo "** Serveing content locally..."
	bundle exec jekyll serve ${EXTRA_ARGS} --host ${LOCAL_SERVER_ADDR}

update:
	@echo "** Update dependencies..."
	bundle update
	bower update
