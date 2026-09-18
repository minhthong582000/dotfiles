# Dotfiles installer.
# Each entry in LINKS is "<path in repo>:<target in $HOME>".
# To add a new config: put it in a folder here and append a line to LINKS.

DOTFILES := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

LINKS := \
	zsh/.zshrc:$(HOME)/.zshrc \
	zsh/.zprofile:$(HOME)/.zprofile \
	ghostty/config.ghostty:$(HOME)/.config/ghostty/config.ghostty \
	starship/starship.toml:$(HOME)/.config/starship.toml

.DEFAULT_GOAL := help
.PHONY: help install brew link unlink check switch update

help: ## Show available targets
	@grep -E '^[a-z-]+:.*## ' $(MAKEFILE_LIST) | awk -F':.*## ' '{printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'

install: brew link ## Install packages and link all configs

brew: ## Install packages from Brewfile
	brew bundle --file=$(DOTFILES)/Brewfile

# First run bootstraps darwin-rebuild via `nix run`; afterwards it is on PATH.
switch: ## Apply flake.nix (Homebrew + macOS settings) via nix-darwin
	@if command -v darwin-rebuild >/dev/null; then \
		sudo darwin-rebuild switch --flake $(DOTFILES); \
	else \
		sudo nix --extra-experimental-features 'nix-command flakes' \
			run nix-darwin/nix-darwin-26.05#darwin-rebuild -- switch --flake $(DOTFILES); \
	fi

update: ## Bump pinned versions in flake.lock
	nix flake update --flake $(DOTFILES)

link: ## Symlink configs into $HOME (existing files are backed up to *.bak)
	@for pair in $(LINKS); do \
		src="$(DOTFILES)/$${pair%%:*}"; dst="$${pair#*:}"; \
		mkdir -p "$$(dirname "$$dst")"; \
		if [ -e "$$dst" ] && [ ! -L "$$dst" ]; then \
			mv "$$dst" "$$dst.bak"; echo "backup  $$dst -> $$dst.bak"; \
		fi; \
		ln -sfn "$$src" "$$dst"; echo "link    $$dst -> $$src"; \
	done

unlink: ## Remove symlinks created by 'link' (restores *.bak if present)
	@for pair in $(LINKS); do \
		dst="$${pair#*:}"; \
		if [ -L "$$dst" ]; then rm "$$dst"; echo "unlink  $$dst"; fi; \
		if [ -e "$$dst.bak" ]; then mv "$$dst.bak" "$$dst"; echo "restore $$dst"; fi; \
	done

check: ## Validate configs
	zsh -n $(DOTFILES)/zsh/.zshrc $(DOTFILES)/zsh/conf.d/*.zsh
	/Applications/Ghostty.app/Contents/MacOS/ghostty +validate-config --config-file=$(DOTFILES)/ghostty/config.ghostty
	STARSHIP_CONFIG=$(DOTFILES)/starship/starship.toml starship print-config >/dev/null
