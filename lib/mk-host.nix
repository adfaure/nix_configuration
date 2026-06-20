{lib}: {
  inputs,
  getSystem,
}: toplevel:
lib.nixosSystem {
  # TODO: understand that.
  specialArgs = {unstable = (getSystem "x86_64-linux").allModuleArgs.unstable;};
  modules =
    [
      (toplevel + "/configuration.nix")
      (toplevel + "/hardware.nix")

      inputs.home-manager.nixosModules.home-manager
    ]
    ++
    # Inject my list of modules
    (lib.mapAttrsToList (name: value: value) inputs.self.nixosModules);
}
