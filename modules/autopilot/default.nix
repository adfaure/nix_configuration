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
    (name: value: lib.mkHost {inherit inputs;} (hosts + "/${name}"))
    (lib.readDir hosts);

  flake.homeConfigurations.adfaure =
    # TODO: how to properly handle system ?
    lib.mkHome inputs "x86_64-linux" "adfaure";
}
