{
  description = "sir's macOS config (nix-darwin)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nix-darwin, ... }:
    {
      # Name must match `scutil --get LocalHostName` so `darwin-rebuild switch --flake .`
      # picks it without needing `#host`.
      darwinConfigurations."thongdepzai-mac" = nix-darwin.lib.darwinSystem {
        modules = [ ./darwin/configuration.nix ];
      };
    };
}
