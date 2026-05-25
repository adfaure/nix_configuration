{ lib, ... }: {
  readDir = lib.readDir;

  # Cannot use findFile because it return an error in case of failure
  findFile = lib.findFile;

  mapPackages = topLevel:
    lib.mapAttrs 
      (name: _: topLevel + "/${name}")
      (lib.readDir topLevel);
}
