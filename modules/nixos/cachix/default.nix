{ lib, ... }: {
  config,
  pkgs,
  ...
}: let
  cfg = config.adfaure.nixosModules.cachix;

  folder = ./caches;
  toImport = name: value: folder + ("/" + name);
  filterCaches = key: value: value == "regular" && lib.hasSuffix ".nix" key;
  # imports = lib.mapAttrsToList toImport (lib.filterAttrs filterCaches (builtins.readDir folder));

in {
  options.adfaure.nixosModules.cachix = {
    enable = lib.mkEnableOption "cachix";
  };

  config = lib.mkIf cfg.enable {
    # inherit imports;
    nix.settings.substituters = ["https://cache.nixos.org/"];
    environment.systemPackages = [pkgs.cachix];
  };
}
