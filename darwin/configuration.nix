# nix-darwin: system settings + Homebrew. Apply with `make switch`.
# Options: https://nix-darwin.github.io/nix-darwin/manual/
{ ... }:

{
  nixpkgs.hostPlatform = "aarch64-darwin";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # User that `system.defaults` and `homebrew` apply to.
  system.primaryUser = "minhthong";

  # Keep /etc/zshrc minimal — ~/.zshrc already runs compinit and starship.
  programs.zsh = {
    enableCompletion = false;
    enableBashCompletion = false;
    promptInit = "";
  };

  # --- Homebrew --------------------------------------------------------------
  # nix-darwin generates a Brewfile from this and runs `brew bundle` on switch.
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;  # don't `brew update` on every switch
      upgrade = false;     # upgrade explicitly: `brew upgrade`
      # "none" leaves unlisted packages alone. Switch to "zap" once this list is
      # complete to make it the single source of truth (unlisted = uninstalled).
      cleanup = "none";
    };

    taps = [ "derailed/k9s" ];

    brews = [
      # Prompt + shell
      "starship"
      "zsh-autosuggestions"
      "zsh-syntax-highlighting"
      "fzf"
      "zoxide"

      # Dev / infra
      "gh"
      "helm"
      "kind"
      "derailed/k9s/k9s"
      "gnu-tar"
      "poppler"
      "python@3.12"
      "python@3.14"
      "bash-completion@2"
    ];

    casks = [
      "ghostty"
      "copilot-cli"
      "font-jetbrains-mono-nerd-font"
    ];
  };

  # --- macOS settings --------------------------------------------------------
  # Values below mirror what this Mac already had (read via `defaults read`),
  # so the first switch changes nothing. Edit here from now on.
  system.defaults = {
    dock = {
      autohide = true;
      tilesize = 58;
      show-recents = false;
      mru-spaces = false;              # don't reorder Spaces by recent use
      minimize-to-application = true;
    };

    finder = {
      FXPreferredViewStyle = "Nlsv";   # list view
    };

    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      NSAutomaticCapitalizationEnabled = true;
      NSAutomaticPeriodSubstitutionEnabled = true;
    };

    trackpad.Clicking = true;          # tap to click

    # Ideas to try (uncomment, then `make switch`):
    # finder.ShowPathbar = true;
    # finder.AppleShowAllFiles = true;
    # NSGlobalDomain.ApplePressAndHoldEnabled = false;  # key repeat instead of accent popup
    # NSGlobalDomain.KeyRepeat = 2;
    # NSGlobalDomain.InitialKeyRepeat = 15;
  };

  # Touch ID for sudo (survives macOS updates, unlike editing /etc/pam.d/sudo).
  # security.pam.services.sudo_local.touchIdAuth = true;

  # Read the changelog (`darwin-rebuild changelog`) before changing.
  system.stateVersion = 6;
}
