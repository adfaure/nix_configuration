{
  lib,
  inputs,
  config,
  self,
  ...
}: {
  flake = {
    # Concrete Home Manager configuration.
    homeConfigurations.lune = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {system = "x86_64-linux";};

      modules = [
        {
          # nixpkgs.overlays = [ self.overlays.default ];
          nixpkgs.config.allowUnfree = true;

          home = rec {
            username = "adfaure";
            homeDirectory = "/home/${username}";
            stateVersion = "20.09";
          };

          adfaure.services.nix-sops.enable = true;
          adfaure.home-modules.user-timers.enable = lib.mkForce true;
        }

        config.flake.modules.homeManager.base
        config.flake.modules.homeManager.graphical
      ];
    };
  };
}
