.PHONY: test release

BIN     := bin/shove
VERSION := $(shell $(BIN) -V)

SHELLS := /bin/sh /bin/bash /bin/zsh dash

test:
	@for sh in $(SHELLS); do \
		$(BIN) -r t -v -s $$sh; \
	done

release:
	git commit -m $(VERSION)
	git tag -a v$(VERSION) -m $(VERSION)
	git push origin v$(VERSION)
	git push origin master
