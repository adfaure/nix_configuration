{
  inputs,
  lib,
  ...
}: {
  # Import flake modules
  imports = lib.mapAttrsToList (name: _: ../flake + "/${name}") (lib.readDir ../flake);

  flake.nixosModules = lib.loadAll {
    dir = ../nixos;
    args = {inherit inputs lib;};
  };

  flake.homeManagerModules = lib.loadAll {
    dir = ../home;
    args = {inherit inputs lib;};
  };

  flake.nixosConfigurations = let
    hosts = ../../hosts;
  in
    lib.mapAttrs
    (name: value:
      lib.mkHost {inherit inputs;} (hosts + "/${name}") {
        # Find a solution for this...
        nixosModules.cachix.enable = true;
        nixosModules.minimal.enable = true;
        nixosModules.flakes.enable = true;
        nixosModules.gnome.enable = true;
        nixosModules.graphical.enable = true;
        nixosModules.guix.enable = true;
        nixosModules.syncthing.enable = true;
        nixosModules.vm.enable = true;
        nixosModules.user.enable = true;
      })
    (lib.readDir hosts);

  flake.homeConfigurations.adfaure =
    # TODO: how to properly handle system ?
    lib.mkHome inputs "x86_64-linux" "adfaure"
    [
      # TODO: idk what to do with this
      {
        home = rec {
          username = "adfaure";
          homeDirectory = "/home/${username}";
          stateVersion = "20.09";
        };
      }

      {
        homeManagerModules.atuin.enable = true;
        homeManagerModules.base.enable = true;
        homeManagerModules.eza.enable = true;
        homeManagerModules.graphical.enable = true;
        homeManagerModules.nix-sops.enable = true;
        homeManagerModules.ryax.enable = true;
        homeManagerModules.timers.enable = true;
        homeManagerModules.tmux.enable = true;
        homeManagerModules.vim.enable = true;
        homeManagerModules.vim-tmux-panes.enable = true;
        homeManagerModules.yazi.enable = true;
        homeManagerModules.zsh.enable = true;
      }
    ];
}
