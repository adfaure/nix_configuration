{inputs, ...}: {
  perSystem = {system, ...}: {
    formatter = inputs.nixpkgs.legacyPackages.${system}.alejandra;
  };
}
