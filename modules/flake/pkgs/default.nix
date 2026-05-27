{lib, ...}: {
  perSystem = {pkgs, ...}: {
    packages =
      lib.mapPackages
      (p: pkgs.callPackage p {})
      ../../../pkgs;
  };
}
