{lib, inputs, ...}: {
  perSystem = {system, pkgs, ...}: {
    packages =
      lib.mapPackages
      (p: pkgs.callPackage p {})
      ../../../pkgs;
  };
}
