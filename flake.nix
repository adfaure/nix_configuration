 {
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";

  inputs.my-dotfiles = {
    url = "/home/adfaure/dotfiles";
    flake = false;
  };

  outputs = { self, nixpkgs, my-dotfiles, ...}: rec {

    nixosModules.i3 = {
      imports = [ ./modules/services/i3 ];
    };

    nixosConfigurations.roger = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      extraArgs = {
        inherit my-dotfiles;
      };
      modules =
        [
          # I3 services required by the graphical module
          nixosModules.i3

          # Module for my programs
          ./modules/programs/vim
          ./modules/programs/ranger
          ./modules/programs/zsh

          # Default linux configuration: users, fonts etc
          ./modules/profiles/common
          # Server X configuration, also activate i3
          ./modules/profiles/graphical

          ./deployments/configuration-roger.nix
        ];
    };
  };
}