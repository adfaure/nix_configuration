{
  inputs,
  config,
  ...
}: {
  flake = {
    # Concrete Home Manager configuration.
    homeConfigurations.noco = inputs.home-manager.lib.homeManagerConfiguration {
      # inherit extraSpecialArgs pkgs;

      # Hardcoded system ?
      pkgs = import inputs.nixpkgs {system = "x86_64-linux";};

      modules = [
        {
          adfaure.services.nix-sops.enable = true;
          adfaure.ryax.enable = true;
          adfaure.home-modules.user-timers.enable = false;
        }
        config.flake.modules.homeManager.base
      ];
    };
  };
}
