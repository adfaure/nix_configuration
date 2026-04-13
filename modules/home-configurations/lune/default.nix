{
  lib,
  inputs,
  config,
  ...
}: {
  flake = {
    # Concrete Home Manager configuration.
    homeConfigurations.lune = inputs.home-manager.lib.homeManagerConfiguration {
      # inherit extraSpecialArgs pkgs;

      # Hardcoded system ?
      pkgs = import inputs.nixpkgs {system = "x86_64-linux";};

      modules = [
        {
          adfaure.services.nix-sops.enable = true;
          adfaure.home-modules.user-timers.enable = lib.mkForce true;
        }
        config.flake.modules.homeManager.base
      ];
    };
  };
}
