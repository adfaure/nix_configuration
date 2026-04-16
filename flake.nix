{
  description = "My personnal configuration";
  inputs = {
    sops-nix.url = "github:Mic92/sops-nix";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    my-dotfiles = {
      url = "github:adfaure/dotfiles";
      # url = "/home/adfaure/code/dotfiles";
      # It is possible to pin the revision with:
      # To be fully reproducible, I can pin my repos
      # "github:/adfaure/dotfiles?rev=602790e25de91ae166c10b93735bbaea667f7a49";
      flake = false;
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim-config = {
      url = "github:adfaure/nixvim-config";
      # url = "/home/adfaure/Code/nixvim-config";
    };

    # Tooling
    catppuccin.url = "github:catppuccin/nix/a48e70a31616cb63e4794fd3465bff1835cc4246";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        # Load home-manager lib
        inputs.home-manager.flakeModules.home-manager
        inputs.flake-parts.flakeModules.modules

        # Flake-modules
        ./modules/flake-modules/home-builder

        # My package set
        ./modules/pkgs

        # Home modules
        ./modules/home-modules/atuin
        ./modules/home-modules/base
        ./modules/home-modules/eza
        ./modules/home-modules/graphical
        ./modules/home-modules/nix-sops
        ./modules/home-modules/ryax
        ./modules/home-modules/timers
        ./modules/home-modules/tmux
        ./modules/home-modules/user
        ./modules/home-modules/vim-tmux-panes
        ./modules/home-modules/yazi
        ./modules/home-modules/zsh

        # Home configurations
        ./modules/home-configurations/lune
        ./modules/home-configurations/noco

        # Nixos modules
        ./modules/nixos-modules/common
        ./modules/nixos-modules/flakes

        # Hosts
        ./modules/hosts/lune
      ];
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];
      perSystem = {pkgs, ...}: {
        formatter = pkgs.alejandra;
      };
    };
}
