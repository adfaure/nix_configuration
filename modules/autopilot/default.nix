{ inputs, lib, ... }: {

  # Import flake modules
  imports = (lib.mapAttrsToList (name: _: ../flake + "/${name}") (lib.readDir ../flake));

  flake.nixosModules = (lib.loadAll {
      dir = ../nixos;
      args = { inherit inputs lib; };
    });

  flake = {
    homeManagerModules = (lib.loadAll {
      dir = ../home;
      args = { inherit inputs lib; };
    });
  };

}

