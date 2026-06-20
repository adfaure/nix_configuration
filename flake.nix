{
  description = "My personnal configuration";
  inputs = {
    sops-nix.url = "github:Mic92/sops-nix";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim-config = {
      url = "github:adfaure/nixvim-config";
      # url = "/home/adfaure/Code/nixvim-config";
    };
    catppuccin.url = "github:catppuccin/nix/a48e70a31616cb63e4794fd3465bff1835cc4246";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default";

    noctalia.url = "github:noctalia-dev/noctalia-shell/legacy-v4";
    noctalia.inputs.nixpkgs.follows = "nixpkgs";
    noctalia.inputs.noctalia-qs.follows = "noctalia-qs";

    noctalia-qs.url = "github:noctalia-dev/noctalia-qs";
    noctalia-qs.inputs.nixpkgs.follows = "nixpkgs";
    noctalia-qs.inputs.systems.follows = "systems";

    # noctalia-qs.inputs.treefmt-nix.follows = "treefmt";

    autopilot = {
      url = "github:stepbrobd/autopilot";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.parts.follows = "parts";
      inputs.systems.follows = "systems";
    };
  };

  outputs = {...} @ inputs:
    inputs.autopilot.lib.mkFlake
    {
      inherit inputs;

      autopilot = {
        lib = {
          path = ./lib;
          extender = inputs.nixpkgs.lib;
          excludes = ["secrets.yaml"];
          extensions = with inputs; [
            autopilot.lib
            {std = inputs.std.lib;}
          ];
        };

        nixpkgs = {
          config = {
            allowUnfree = true;
          };
          overlays = [
            # self.overlays.default
          ];
          instances = {
            pkgs = inputs.nixpkgs;
            unstable = inputs.nixos-unstable;
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
