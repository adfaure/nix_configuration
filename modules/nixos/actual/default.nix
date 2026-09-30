{lib, ...}: {config, ...}:
with lib; let
  cfg = config.nixosModules.actual;
in {
  options.nixosModules.actual = {
    enable = mkEnableOption "actual";
  };

  config = mkIf cfg.enable {
    services.actual = {
      enable = true;
    };
  };
}
