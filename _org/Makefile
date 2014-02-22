EMACS=emacs
ORG_CONFIG_FILE=publish-config.el
EMACS_OPTS=--batch --eval "(load-file \"$(ORG_CONFIG_FILE)\")" -f myweb-publish

DEST_HOST='holbrook.github.com:public_html/'
# OUTPUT_DIR=output

all: html upload

html:
	@echo "Generating HTML..."
#	@mkdir -p $(OUTPUT_DIR)
	@$(EMACS) $(EMACS_OPTS)
	@echo "HTML generation done"

upload: clean_bak

        @cd $(OUTPUT_DIR) && scp -r . $(DEST_HOST) && cd ..

clean: clean_bak

#clean_output:
#	@rm -rf $(OUTPUT_DIR)

clean_bak:
	@find . | grep ~$$ | while read l; do rm $$l; done
