{lib, ...}: inputs: username: {
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
