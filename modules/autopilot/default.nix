# This is the "entrypoint" that will be invoked by autopilot and construct the
# flake tree.
{
  inputs,
  lib,
  ...
}: {
  # Import flake modules
  imports = lib.mapAttrsToList (name: _: ../flake + "/${name}") (lib.readDir ../flake);

  # Load all modules so that they can be accessed
  # from inputs.self.{nixosModules,homeManagerModules}
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
    lib.mkHome inputs "x86_64-linux" "adfaure";
}
