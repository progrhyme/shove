.PHONY: test release

BIN     := bin/shove
VERSION := $(shell $(BIN) -V)

SHELLS := /bin/sh /bin/bash /bin/zsh dash
TESTS  := t/basic.t t/group.t

test:
	@for sh in $(SHELLS); do \
		for t in $(TESTS); do \
			$(BIN) $$t -s $$sh; \
		done \
	done

release:
	git commit -m $(VERSION)
	git tag -a v$(VERSION) -m $(VERSION)
	git push origin v$(VERSION)
	git push origin master
