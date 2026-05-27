{lib}: {inputs}: toplevel: extraModule:
lib.nixosSystem {
  specialArgs = {};
  modules =
    [
      (toplevel + "/configuration.nix")
      (toplevel + "/hardware.nix")
      extraModule
    ]
    ++
    # Inject my list of modules
    (lib.mapAttrsToList (name: value: value) inputs.self.nixosModules);
}
