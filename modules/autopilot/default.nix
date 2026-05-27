{ inputs, lib, nixpkgs, getSystem, ... }: {
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

  flake.nixosConfigurations.lune = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {};
    modules = [
      # Host configuration
      ../../hosts/lune/configuration.nix
      ../../hosts/lune/hardware.nix

      {
        nixosModules.common.enable = true;
        nixosModules.graphical.enable = true;
        nixosModules.gnome.enable = true;
        nixosModules.flakes.enable = true;
        nixosModules.guix.enable = true;
        nixosModules.vm.enable = true;
        nixosModules.syncthing.enable = true;
        nixosModules.cachix.enable = true;
      }

      inputs.determinate.nixosModules.default
    ] ++
      # Inject my list of modules
      (lib.mapAttrsToList (name: value: value) inputs.self.nixosModules);
  };
}
