{
  description = "My personnal configuration";
  inputs = {
    # I need a custom nix version because of this issue: https://github.com/NixOS/nix/commit/8af4f886e212346afdd1d40789f96f1321da96c5
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    my-dotfiles = {
      url = "github:adfaure/dotfiles";
      # url = "/home/adfaure/Projects/dotfiles";
      # It is possible to pin the revision with:
      # To be fully reproducible, I can pin my repos
      # "github:/adfaure/dotfiles?rev=602790e25de91ae166c10b93735bbaea667f7a49";
      flake = false;
    };
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixos-unstable";
    # nur-kapack = { url = "/home/adfaure/Projects/nur-kapack"; };
    nur.url = "github:nix-community/NUR";
    # Emacs overlay
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixos-unstable,
    my-dotfiles,
    home-manager,
    emacs-overlay,
    nur,
  }: let
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      config.allowUnfree = true;
      overlays = [emacs-overlay.overlay];
    };
    unstable = import nixos-unstable {
      system = "x86_64-linux";
      config.allowUnfree = true;
      overlays = [emacs-overlay.overlay];
    };
  in {
    packages.x86_64-linux = {
      # Programs
      cgvg = pkgs.callPackage ./pkgs/cgvg {};
      myVscode = unstable.callPackage ./pkgs/vscode {};
      myEmacs = pkgs.callPackage ./pkgs/emacs {inherit my-dotfiles;};
      cadvisor = pkgs.callPackage ./pkgs/cadvisor {};
      nix = unstable.nix;
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
        inherit my-dotfiles emacs-overlay home-module;
        nixpkgs = nixos-unstable;
        cgvg = self.packages.x86_64-linux.cgvg;
      };
    in {
      adfaure = home-manager.lib.homeManagerConfiguration rec {
        inherit extraSpecialArgs;
        pkgs = unstable;
        modules = [
          home-module
          ./homes/adfaure.nix
          ./homes/base.nix
        ];
      };

      base = home-manager.lib.homeManagerConfiguration rec {
        inherit extraSpecialArgs;
        pkgs = unstable;
        modules = [
          home-module
          ./homes/base.nix
        ];
      };

      wsl = home-manager.lib.homeManagerConfiguration rec {
        inherit extraSpecialArgs;
        pkgs = unstable;
        modules = [
          home-module
          ./homes/wsl.nix
        ];
      };
    };

    # Overlay to inject my packages in the different modules
    overlays.default = final: prev: {
      cadvisor = self.packages.x86_64-linux.cadvisor;
      cgvg = self.packages.x86_64-linux.cgvg;
      myVscode = self.packages.x86_64-linux.myVscode;
      myEmacs = self.packages.x86_64-linux.myEmacs;
      nixFlakes = self.packages.x86_64-linux.nix;
    };

    nixosModules.overlay = {pkgs, ...}: {
      nixpkgs.overlays = [self.overlays.default];
    };

    nixosConfigurations = {
      # Configuration for my current working machine.
      roger = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # extra arguments will be injected into the modules.
        extraArgs = {inherit my-dotfiles nur;};
        modules = [
          # Main configuration, includes the hardware file and the module list
          ./deployments/configuration-roger.nix
        ];
      };

      adchire = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        extraArgs = {inherit my-dotfiles nur;};
        modules = [
          self.nixosModules.overlay
          # Main configuration, includes the hardware file and the module list
          ./deployments/configuration-adchire.nix
        ];
      };
    };

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
    checks.x86_64-linux = with import nixpkgs {system = "x86_64-linux";}; {
      cgvg = self.packages.x86_64-linux.cgvg;
    };
  };
}
