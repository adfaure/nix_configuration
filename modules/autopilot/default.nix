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
        nixosModules.common.enable = true;
        nixosModules.graphical.enable = true;
        nixosModules.gnome.enable = true;
        nixosModules.flakes.enable = true;
        nixosModules.guix.enable = true;
        nixosModules.vm.enable = true;
        nixosModules.syncthing.enable = true;
        nixosModules.cachix.enable = true;
      })
    (lib.readDir hosts);
}
