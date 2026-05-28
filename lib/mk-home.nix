{lib}: inputs: system: user: modules: let
  # system = "x86_64-linux";
  pkgs = import inputs.nixpkgs {
    inherit system;
  };
in
  inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs;

    modules =
      [
        inputs.sops-nix.homeManagerModules.sops
        inputs.catppuccin.homeManagerModules.catppuccin
      ]
      ++ modules
      ++
      # Inject my list of modules
      (lib.mapAttrsToList (name: value: value) inputs.self.homeManagerModules);
  }
