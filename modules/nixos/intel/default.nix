{lib, ...}: {
  config,
  ...
}:
with lib; let
  cfg = config.nixosModules.intel;
  hasTag = lib.hasTag config.networking.hostName;
in {
  options.nixosModules.intel = {
    enable = lib.mkOption {
      default = hasTag "intel";
    };
  };

  config = mkIf cfg.enable {
    services.thermald.enable = true;
  };
}
