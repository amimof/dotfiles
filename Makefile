BIN      = $(CURDIR)/bin
GO			 = go
TIMEOUT  = 15
V = 0
Q = $(if $(filter 1,$V),,@)
M = $(shell printf "\033[34;1m➜\033[0m")

$(BIN):
	@mkdir -p $(BIN)
$(BIN)/%: | $(BIN) ; $(info $(M) building $(PACKAGE))
	$Q tmp=$$(mktemp -d); \
	   env GO111MODULE=off GOPATH=$$tmp GOBIN=$(BIN) $(GO) get $(PACKAGE) \
		|| ret=$$?; \
	   rm -rf $$tmp ; exit $$ret

MISSPELL = $(BIN)/misspell
$(BIN)/misspell: PACKAGE=github.com/client9/misspell/cmd/misspell

# Build
all: 
	stow -v --dotfiles -R -t $$HOME */

delete: 
	stow -v --dotfiles -D -t $$HOME */

# Tests

.PHONY: misspell
misspell: | $(MISSPELL) ; $(info $(M) running misspell) @ ## Finds commonly misspelled English words
	$Q $(MISSPELL) .

.PHONY: test
test: mis

# Misc
.PHONY: help
help:
	@grep -hE '^[ a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m∙ %s:\033[0m %s\n", $$1, $$2}'

.PHONY: version
version:	## Print version information
	@echo App: $(VERSION)
	@echo Go: $(GOVERSION)
	@echo Commit: $(COMMIT)
	@echo Branch: $(BRANCH)

.PHONY: clean
clean: ; $(info $(M) cleaning)	@ ## Cleanup everything
	@rm -rfv $(BIN)
