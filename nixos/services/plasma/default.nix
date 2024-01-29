{
  config,
  lib,
  pkgs,
  my-dotfiles,
  ...
}:
with lib; let
  cfg = config.environment.adfaure.services.plasma;
in {
  options.environment.adfaure.services.plasma = {
    enable = mkEnableOption "plasma";
  };

  config = mkIf cfg.enable {
    services.xserver.enable = true;
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.desktopManager.plasma5.enable = true;

    environment.plasma5.excludePackages = with pkgs.libsForQt5; [
      plasma-browser-integration
      konsole
      oxygen
    ];

    services.xserver.displayManager.defaultSession = "plasmawayland";
  };
}
