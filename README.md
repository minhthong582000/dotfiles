# dotfiles

A place where I keep my dotfiles, configs and scripts with Nix!

```txt
.
├── flake.nix             # nix-darwin entry point (pins nixpkgs + nix-darwin)
├── darwin/
│   └── configuration.nix # Homebrew packages + macOS settings (system.defaults)
├── Brewfile              # legacy; superseded by darwin/configuration.nix
├── Makefile              # install / link / unlink / check
├── zsh/
│   ├── .zprofile         # login shell (brew, OrbStack)
│   ├── .zshrc            # entry point, sources conf.d/*.zsh in order
│   └── conf.d/           # one file per concern: 00-path, 10-history, ... 80-prompt, 90-plugins
├── ghostty/
│   └── config.ghostty    # -> ~/.config/ghostty/config.ghostty
└── starship/
    └── starship.toml     # -> ~/.config/starship.toml (Catppuccin Mocha, k8s/docker/aws on the right)
```

## Usage

```sh
make install   # brew bundle + symlink everything
make link      # only (re)create symlinks
make unlink    # remove symlinks, restore backups
make check     # syntax-check zsh + validate ghostty & starship configs
make switch    # apply darwin/configuration.nix (brew packages + macOS settings)
make update    # bump flake.lock
```

## nix-darwin (first time)

```sh
curl -L https://nixos.org/nix/install | sh   # install Nix, then open a new terminal
git add flake.nix darwin/                     # flakes only see files git knows about
make switch                                   # first run bootstraps darwin-rebuild
```

## Secrets

Put tokens, keys and machine-specific settings in `~/.zshrc.local`. It is sourced
at the end of `.zshrc`.
