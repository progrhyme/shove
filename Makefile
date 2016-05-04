.PHONY: test shpec release

BIN     := bin/shove
VERSION := $(shell $(BIN) -V)

SHELLS := sh bash dash ksh zsh

test:
	@set -e; \
	for sh in $(SHELLS); do \
		if which $$sh >/dev/null 2>&1; then \
			$(BIN) -r t -v -s $$sh; \
		else \
			echo "$$sh is not found. skip."; \
		fi; \
	done

shpec:
	@if ! which shpec >/dev/null 2>&1; then \
		echo "shpec not found. quit."; \
		exit 1; \
	fi
	@set -e; \
	for sh in $(SHELLS); do \
		if which $$sh >/dev/null 2>&1; then \
			echo "# shpec by $$sh"; \
			$$sh `which shpec`; \
		else \
			echo "$$sh is not found. skip."; \
		fi; \
	done

release:
	git commit -m $(VERSION)
	git tag -a v$(VERSION) -m $(VERSION)
	git push origin v$(VERSION)
	git push origin master
