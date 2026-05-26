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
    parts ={
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default";
    autopilot = {
      url = "github:stepbrobd/autopilot";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.parts.follows = "parts";
      inputs.systems.follows = "systems";
    };
  };

  outputs =
    { self, ... }@inputs:
    inputs.autopilot.lib.mkFlake
      {
        inherit inputs;

        autopilot = {
          lib = {
            path = ./lib;
            extender = inputs.nixpkgs.lib;
            excludes = [ "secrets.yaml" ];
            extensions = with inputs; [
              autopilot.lib
              { std = inputs.std.lib; }
            ];
          };

          nixpkgs = {
            config = {
              allowUnfree = true;
              allowDeprecatedx86_64Darwin = true;
            };
            overlays = [
              # self.overlays.default
            ];
            instances = {
              pkgs = inputs.nixpkgs;
            };
          };
          parts.path = ./modules/autopilot;
        };
      }
      {
        debug = true;
        systems = import inputs.systems;
      };
  }



      # # Separated home-manager config for non-nixos machines.
      # # Activate with: home-manager --flake .#adfaure switch
      # homeConfigurations = let
      #   home-module = {
      #     nixpkgs.overlays = [self.overlays.default];
      #     nixpkgs.config.allowUnfree = true;
      #     home = rec {
      #       username = "adfaure";
      #       homeDirectory = "/home/${username}";
      #       stateVersion = "20.09";
      #     };
      #   };
      #   extraSpecialArgs = {
      #     inherit my-dotfiles home-module unstable nixvim-config system;
      #   };
      # in {
      #   noco = import ./homes/configurations/noco {
      #     inherit
      #       pkgs
      #       home-manager
      #       home-module
      #       sops-nix
      #       catppuccin
      #       extraSpecialArgs
      #       ;
      #   };
      #   lune = import ./homes/configurations/lune {
      #     inherit
      #       pkgs
      #       home-manager
      #       home-module
      #       sops-nix
      #       catppuccin
      #       extraSpecialArgs
      #       ;
      #   };
      #   # Can be use in VPS for instance without graphical installation
      #   base = home-manager.lib.homeManagerConfiguration {
      #     inherit extraSpecialArgs;
      #     modules = [
      #       home-module
      #       sops-nix.homeManagerModules.sops
      #       ./homes/base.nix
      #     ];
      #   };
      # };

      # packages.${system} = rec {
      #   # Programs
      #   cgvg = pkgs.callPackage ./pkgs/cgvg {};
      #   cgvg-rs = pkgs.callPackage ./pkgs/rgvg {};
      #   nix = unstable.nix;
      #   hakuneko-nightly = pkgs.callPackage ./pkgs/hakuneko-nightly {};
      # };

      # # Overlay to inject my packages in the different modules
      # overlays.default = final: prev: {
      #   cgvg = self.packages.${system}.cgvg;
      #   cgvg-rs = self.packages.${system}.cgvg-rs;
      # };

      # nixosModules.overlay = {...}: {
      #   nixpkgs.overlays = [self.overlays.default];
      # };

      # nixosConfigurations = {
      #   lune = import ./nixos/hosts/lune { inherit system inputs; };
      #   noco = import ./nixos/hosts/noco { inherit system inputs; };
      # };

      # templates = {
      #   rust = {
      #     path = ./templates/rust;
      #     description = "Rust devshell";
      #   };

      #   python = {
      #     path = ./templates/simple-with-python;
      #     description = "Simple devshell with python example";
      #   };
      # };

      # formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
