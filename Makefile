.PHONY: test doc release

BIN     := bin/shove
VERSION := $(shell $(BIN) -v)

SHELLS := /bin/sh /bin/bash /bin/zsh dash

test:
	@for sh in $(SHELLS); do \
		( SHOVE_SHELL=$$sh $(BIN) t/basic.t ) \
	done

doc: README.md
	pod2markdown $(BIN) > README.md

release:
	git commit -m $(VERSION)
	git tag -a v$(VERSION) -m $(VERSION)
	git push origin v$(VERSION)
	git push origin master
