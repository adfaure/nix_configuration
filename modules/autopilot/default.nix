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
        adfaure.nixosModules.common.enable = true;
        adfaure.nixosModules.graphical.enable = true;
        adfaure.nixosModules.gnome.enable = true;
        adfaure.nixosModules.flakes.enable = true;
        adfaure.nixosModules.guix.enable = true;
        adfaure.nixosModules.vm.enable = true;
        adfaure.nixosModules.syncthing.enable = true;
        adfaure.nixosModules.cachix.enable = true;
      }

      inputs.determinate.nixosModules.default
    ] ++
      # Inject my list of modules
      (lib.mapAttrsToList (name: value: value) inputs.self.nixosModules);
  };
}
