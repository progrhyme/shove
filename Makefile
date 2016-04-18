.PHONY: test

SHELLS := /bin/sh /bin/bash /bin/zsh dash

test:
	@for sh in $(SHELLS); do \
		( SHOVE_SHELL=$$sh bin/shove t/basic.t ) \
	done
