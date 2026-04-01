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
        ./modules/pkgs
        # To import an internal flake module: ./other.nix
        # To import an external flake module:
        #   1. Add foo to inputs
        #   2. Add foo as a parameter to the outputs function
        #   3. Add here: foo.flakeModule
      ];
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];
      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
        # Per-system attributes can be defined here. The self' and inputs'
        # module parameters provide easy access to attributes of the same
        # system.

        # packages.myVscode = inputs'.nixos-unstable.pkgs.callPackage ./pkgs/vscode {};
        # packages.nix = inputs'.nixos-unstable.nix;
        formatter = pkgs.alejandra;
      };
      flake = {
        # The usual flake attributes can be defined here, including system-

        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.
      };
    };

  # outputs = {
  #   nixpkgs,
  #   nixos-unstable,
  # }: let
  #   system = "x86_64-linux";
  #   pkgs = import nixpkgs {
  #     inherit system;
  #     config.allowUnfree = true;
  #     overlays = [];
  #   };
  #   unstable = import nixos-unstable {
  #     inherit system;
  #     config.allowUnfree = true;
  #     overlays = [];
  #   };
  # in {
  #   packages.${system} = rec {

  #   };
  # };
}
