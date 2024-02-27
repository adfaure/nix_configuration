{
  description = "My personnal configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    my-dotfiles = {
      url = "github:adfaure/dotfiles";
      # url = "/home/adfaure/dotfiles";
      # It is possible to pin the revision with:
      # To be fully reproducible, I can pin my repos
      # "github:/adfaure/dotfiles?rev=602790e25de91ae166c10b93735bbaea667f7a49";
      flake = false;
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixos-unstable,
    my-dotfiles,
    home-manager,
    nur,
    emacs-overlay,
  }: let
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      config.allowUnfree = true;
      overlays = [(import self.inputs.emacs-overlay)];
    };
    unstable = import nixos-unstable {
      system = "x86_64-linux";
      config.allowUnfree = true;
      overlays = [];
    };
  in {
    packages.x86_64-linux = rec {
      # Programs
      cgvg = pkgs.callPackage ./pkgs/cgvg {};
      myVscode = unstable.callPackage ./pkgs/vscode {};
      myEmacs = pkgs.callPackage ./pkgs/emacs {inherit my-dotfiles;};
      simplematch = unstable.callPackage ./pkgs/simplematch {};
      ExifRead = unstable.callPackage ./pkgs/exifread {};
      organize = unstable.callPackage ./pkgs/organize { inherit simplematch ExifRead; };
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
        inherit my-dotfiles home-module unstable;
        # nixpkgs = nixos-unstable;
        cgvg = self.packages.x86_64-linux.cgvg;
      };
    in {
      adfaure = home-manager.lib.homeManagerConfiguration rec {
        inherit extraSpecialArgs pkgs;
        modules = [
          home-module
          ./homes/adfaure.nix
          ./homes/base.nix
        ];
      };

      base = home-manager.lib.homeManagerConfiguration rec {
        inherit extraSpecialArgs;
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
      cgvg = self.packages.x86_64-linux.cgvg;
      myVscode = self.packages.x86_64-linux.myVscode;
      myEmacs = self.packages.x86_64-linux.myEmacs;
      nixFlakes = self.packages.x86_64-linux.nix;
    };

    nixosModules.overlay = {pkgs, ...}: {
      nixpkgs.overlays = [self.overlays.default];
    };

    nixosConfigurations = {
      gouttelette = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit my-dotfiles;};
        modules = [
          self.nixosModules.overlay
          # Main configuration, includes the hardware file and the module list
          ./deployments/configuration-gouttelette.nix
        ];
      };

      roger = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit my-dotfiles;};
        modules = [
          # Main configuration, includes the hardware file and the module list
          ./deployments/configuration-roger.nix
        ];
      };

      altitude = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit my-dotfiles;};
        modules = [
          self.nixosModules.overlay
          # Main configuration, includes the hardware file and the module list
          ./deployments/configuration-altitude.nix
        ];
      };
    };

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
    checks.x86_64-linux = with import nixpkgs {system = "x86_64-linux";}; {
      cgvg = self.packages.x86_64-linux.cgvg;
    };
  };
}
