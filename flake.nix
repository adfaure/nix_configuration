{
  description = "My personnal configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
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
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    catppuccin.url = "github:catppuccin/nix/a48e70a31616cb63e4794fd3465bff1835cc4246";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixos-unstable,
    my-dotfiles,
    home-manager,
    emacs-overlay,
    catppuccin,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [(import self.inputs.emacs-overlay)];
    };
    unstable = import nixos-unstable {
      inherit system;
      config.allowUnfree = true;
      overlays = [];
    };
  in {
    packages.${system} = rec {
      # Programs
      cgvg = pkgs.callPackage ./pkgs/cgvg {};
      myVscode = unstable.callPackage ./pkgs/vscode {};
      myEmacs = pkgs.callPackage ./pkgs/emacs {inherit my-dotfiles;};
      simplematch = unstable.callPackage ./pkgs/simplematch {};
      ExifRead = unstable.callPackage ./pkgs/exifread {};
      organize = unstable.callPackage ./pkgs/organize {inherit simplematch ExifRead;};
      obsidian-nvim = pkgs.callPackage ./pkgs/obsidian-nvim {};
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
        cgvg = self.packages.${system}.cgvg;
      };
    in {
      adfaure = home-manager.lib.homeManagerConfiguration rec {
        inherit extraSpecialArgs pkgs;
        modules = [
          home-module
          catppuccin.homeManagerModules.catppuccin
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
      cgvg = self.packages.${system}.cgvg;
      myVscode = self.packages.${system}.myVscode;
      myEmacs = self.packages.${system}.myEmacs;
      organize = self.packages.${system}.organize;
      nixFlakes = self.packages.${system}.nix;
      obsidian-nvim = self.packages.${system}.obsidian-nvim;
    };

    nixosModules.overlay = {pkgs, ...}: {
      nixpkgs.overlays = [self.overlays.default];
    };

    nixosConfigurations = {
      gouttelette = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit my-dotfiles;};
        modules = [
          self.nixosModules.overlay
          # Main configuration, includes the hardware file and the module list
          ./deployments/configuration-gouttelette.nix
        ];
      };
    };

    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
    checks.${system} = with import nixpkgs {inherit system;}; {
      cgvg = self.packages.${system}.cgvg;
    };
  };
}
