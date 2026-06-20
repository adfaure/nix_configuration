{lib}: {inputs, getSystem}: toplevel:
lib.nixosSystem {
  # TODO: understand that.
  specialArgs = { unstable  = (getSystem "x86_64-linux").allModuleArgs.unstable; };
  modules =
    [
      (toplevel + "/configuration.nix")
      (toplevel + "/hardware.nix")

      inputs.home-manager.nixosModules.home-manager

      # Wire-up all my modules
      # TODO: Find a better solution
      {
        nixosModules.cachix.enable = true;
        nixosModules.minimal.enable = true;
        nixosModules.flakes.enable = true;
        nixosModules.graphical.enable = true;
        nixosModules.guix.enable = true;
        nixosModules.syncthing.enable = true;
        nixosModules.vm.enable = true;
        nixosModules.user.enable = true;
        nixosModules.adfaure.enable = true;

        nixosModules.gnome.enable = false;
        nixosModules.niri.enable = true;
      }
    ]
    ++
    # Inject my list of modules
    (lib.mapAttrsToList (name: value: value) inputs.self.nixosModules);
}
