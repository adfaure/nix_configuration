{ inputs, lib, nixpkgs, getSystem, ... }: {
  # Import flake modules
  imports = (lib.mapAttrsToList (name: _: ../flake + "/${name}") (lib.readDir ../flake));

  flake.nixosModules = (lib.loadAll {
      dir = ../nixos;
      args = { inherit inputs lib; };
      importer = lib.importApplyWithArgs;
    });

  flake = {
    homeManagerModules = (lib.loadAll {
      dir = ../home;
      args = { inherit inputs lib; };
    });
  };

  flake.nixosConfigurations.lune = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {};
    modules = [
      inputs.determinate.nixosModules.default

      ../../hosts/lune/configuration.nix
      ../../hosts/lune/hardware.nix

      inputs.self.nixosModules.guix
    ];
  };
}
