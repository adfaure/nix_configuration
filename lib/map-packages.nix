{ lib, ... }: f: topLevel:
    lib.mapAttrs
      (name: _: f (topLevel + "/${name}"))
      (lib.readDir topLevel)
