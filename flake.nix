 {
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";

  inputs.my-dotfiles = {
    url = "/home/adfaure/dotfiles";
    flake = false;
  };

  outputs = { self, nixpkgs, my-dotfiles, ...}: rec {

    nixosConfigurations.roger = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      extraArgs = {
        inherit my-dotfiles;
      };
      modules =
        [
          # Module for my programs
          ./modules/programs/vim
          ./modules/programs/ranger
          ./modules/programs/zsh

          # Default linux configuration: users, fonts etc
          ./modules/profiles/common

          ./deployments/configuration-roger.nix
        ];
    };
  };
}