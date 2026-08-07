.PHONY: test install-deps clean

# Neovim executable
NVIM ?= nvim

# Run tests. Usage:
#   make test                     - run all tests
#   make test PATTERN=example     - run tests matching "example"
#   make test PATTERN=test/example_spec.lua  - run specific file
test: install-deps
	TEST_PATTERN="$(PATTERN)" $(NVIM) -u test/minimal_init.lua -l test/run.lua

# Install test dependencies (luaunit)
install-deps:
	$(NVIM) -u NONE -l test/install_deps.lua

# Clean up test artifacts
clean:
	rm -rf test/.deps

