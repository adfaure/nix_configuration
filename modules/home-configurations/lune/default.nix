{inputs, ...}: {
  flake = {
    # Concrete Home Manager configuration.
    homeConfigurations.lune = inputs.home-manager.lib.homeManagerConfiguration {
      # inherit extraSpecialArgs pkgs;

      # Hardcoded system ?
      pkgs = import inputs.nixpkgs {system = "x86_64-linux";};

      modules = [
        inputs.self.homeModules.base
      ];
    };
  };
}
