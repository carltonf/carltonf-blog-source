serve:
	@echo "** Serveing content locally..."
	bundle exec jekyll serve

update:
	@echo "** Update dependencies..."
	bundle update
	bower update
