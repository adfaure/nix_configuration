{
  description = "My personnal configuration";
  inputs = {
    sops-nix.url = "github:Mic92/sops-nix";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim-config = {
      url = "github:adfaure/nixvim-config";
    };
    catppuccin.url = "github:catppuccin/nix/a48e70a31616cb63e4794fd3465bff1835cc4246";
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
      myVscode = unstable.callPackage ./pkgs/vscode {};
      simplematch = pkgs.callPackage ./pkgs/simplematch {};
      ExifRead = pkgs.callPackage ./pkgs/exifread {};
      organize = pkgs.callPackage ./pkgs/organize {inherit simplematch ExifRead;};
      obsidian-nvim = pkgs.callPackage ./pkgs/obsidian-nvim {};
      cgvg-rs = pkgs.callPackage ./pkgs/rgvg {};
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
        inherit my-dotfiles home-module unstable nixvim-config system;
      };
    in {
      # Include programs that need X or wayland
      graphical = home-manager.lib.homeManagerConfiguration {
        inherit extraSpecialArgs pkgs;
        modules = [
          home-module
          sops-nix.homeManagerModules.sops
          catppuccin.homeManagerModules.catppuccin
          ./homes/graphical.nix
          ./homes/base.nix
        ];
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

      wsl = home-manager.lib.homeManagerConfiguration {
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
      organize = self.packages.${system}.organize;
      nixFlakes = self.packages.${system}.nix;
      obsidian-nvim = self.packages.${system}.obsidian-nvim;
      cgvg-rs = self.packages.${system}.cgvg-rs;
    };

    nixosModules.overlay = {...}: {
      nixpkgs.overlays = [self.overlays.default];
    };

    nixosConfigurations = {
      gouttelette = import ./systems/goutelette.nix {inherit system inputs;};
      lune = import ./systems/lune.nix {inherit system inputs;};
      # Simple VM so I don't need to reboot when I am experimenting
      # # nix build .#'nixosConfigurations.vm.config.system.build.vm'
      # # ./result/bin/run-nixos-vm

      # user password: nixos
      vm = import ./systems/vm.nix {inherit system inputs unstable;};
    };

    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
    checks.${system} = builtins.listToAttrs (map (name: {
      name = name;
      value = self.packages.${system}.${name};
    }) (builtins.attrNames self.packages.${system}));
  };
}
