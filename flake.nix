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
    catppuccin.url = "github:catppuccin/nix/a48e70a31616cb63e4794fd3465bff1835cc4246";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixos-unstable,
    my-dotfiles,
    home-manager,
    catppuccin,
    nixvim-config,
    sops-nix,
    determinate,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [];
    };
    unstable = import nixos-unstable {
      inherit system;
      config.allowUnfree = true;
      overlays = [];
    };
  in {
    packages.${system} = rec {
      # Programs
      cgvg = pkgs.callPackage ./pkgs/cgvg/default.nix {};
      cgvg-rs = pkgs.callPackage ./pkgs/rgvg {};
      nix = unstable.nix;
      hakuneko-nightly = pkgs.callPackage ./pkgs/hakuneko-nightly {};
    };

    # Separated home-manager config for non-nixos machines.
    # Activate with: home-manager --flake .#adfaure switch
    homeConfigurations = let
      home-module = {
        nixpkgs.overlays = [self.overlays.default];
        nixpkgs.config.allowUnfree = true;
        home = rec {
          username = "adfaure";
          homeDirectory = "/home/${username}";
          stateVersion = "20.09";
        };
      };
      extraSpecialArgs = {
        inherit my-dotfiles home-module unstable nixvim-config system;
      };
    in {
      noco = import ./homes/configurations/noco {
        inherit
          pkgs
          home-manager
          home-module
          sops-nix
          catppuccin
          extraSpecialArgs
          ;
      };
      lune = import ./homes/configurations/lune {
        inherit
          pkgs
          home-manager
          home-module
          sops-nix
          catppuccin
          extraSpecialArgs
          ;
      };
      # Can be use in VPS for instance without graphical installation
      base = home-manager.lib.homeManagerConfiguration {
        inherit extraSpecialArgs;
        modules = [
          home-module
          sops-nix.homeManagerModules.sops
          ./homes/base.nix
        ];
      };
    };

    # Overlay to inject my packages in the different modules
    overlays.default = final: prev: {
      cgvg = self.packages.${system}.cgvg;
      myVscode = self.packages.${system}.myVscode;
      # organize = self.packages.${system}.organize;
      nixFlakes = self.packages.${system}.nix;
      cgvg-rs = self.packages.${system}.cgvg-rs;
    };

    nixosModules.overlay = {...}: {
      nixpkgs.overlays = [self.overlays.default];
    };

    nixosConfigurations = {
      lune = import ./nixos/hosts/lune { inherit system inputs; };
      noco = import ./nixos/hosts/noco { inherit system inputs; };
    };

    templates = {
      rust = {
        path = ./templates/rust;
        description = "Rust devshell";
      };

      python = {
        path = ./templates/simple-with-python;
        description = "Simple devshell with python example";
      };
    };

    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
  };
}
