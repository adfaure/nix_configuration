{lib}: inputs: system: username: let
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
        {
          home = {
            inherit username;
            homeDirectory = "/home/${username}";
          };
        }

        (../users + "/${username}")
      ]
      ++
      # Inject my list of modules
      (lib.mapAttrsToList (name: value: value) inputs.self.homeManagerModules);
  }
