{
  perSystem = {pkgs, ...}: {
    # Programs
    packages = {
      cgvg-rs = pkgs.callPackage ./rgvg {};
      hakuneko-nightly = pkgs.callPackage ./hakuneko-nightly {};
    };
  };
}
