{lib, ...}: {
  config,
  ...
}:
with lib; let
  cfg = config.nixosModules.guix;
  hasTag = lib.hasTag osConfig.networking.hostName;
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
