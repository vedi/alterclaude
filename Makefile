PREFIX ?= $(HOME)/.local
VERSION := $(shell cat VERSION)

.PHONY: install install-dev uninstall dist doctor check check-private

install:
	./install.sh --prefix=$(PREFIX)

install-dev:
	./install.sh --dev --prefix=$(PREFIX)

uninstall:
	rm -f $(PREFIX)/bin/alterclaude $(PREFIX)/bin/claude-swap
	@echo "данные ~/.claude-profiles не тронуты"

check: check-private
	bash -n alterclaude
	bash -n install.sh

check-private:
	@bad=0; \
	for f in work personal .active code-sessions-canonical backups \
		Cookies Cookies-journal config.json "Local Storage" \
		"Session Storage" WebStorage IndexedDB Partitions \
		ant-did ant-device-registry.json buddy-tokens.json; do \
		if [ -e "$$f" ]; then echo "private file in tree: $$f"; bad=1; fi; \
	done; \
	if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then \
		tracked="$$(git ls-files work personal .active code-sessions-canonical backups Cookies config.json ant-did buddy-tokens.json 2>/dev/null || true)"; \
		if [ -n "$$tracked" ]; then echo "private file tracked:"; echo "$$tracked"; bad=1; fi; \
	fi; \
	[ "$$bad" = 0 ] || exit 1; \
	echo "check-private: OK"

doctor:
	$(PREFIX)/bin/alterclaude doctor

dist: check
	rm -rf dist/stage
	mkdir -p dist/stage/alterclaude-$(VERSION)
	cp alterclaude install.sh README.md Makefile VERSION LICENSE .gitignore \
		dist/stage/alterclaude-$(VERSION)/
	tar -C dist/stage -czf dist/alterclaude-$(VERSION).tar.gz alterclaude-$(VERSION)
	rm -rf dist/stage
	@echo "dist/alterclaude-$(VERSION).tar.gz"
