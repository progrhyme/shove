.PHONY: test release

BIN     := bin/shove
VERSION := $(shell $(BIN) -V)

SHELLS := sh bash dash zsh

test:
	@set -e; \
	for sh in $(SHELLS); do \
		if which $$sh >/dev/null 2>&1; then \
			$(BIN) -r t -v -s $$sh; \
		else \
			echo "$$sh is not found. skip."; \
		fi; \
	done

release:
	git commit -m $(VERSION)
	git tag -a v$(VERSION) -m $(VERSION)
	git push origin v$(VERSION)
	git push origin master
