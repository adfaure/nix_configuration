{
  config,
  lib,
  pkgs,
  my-dotfiles,
  ...
}:
with lib; let
  cfg = config.environment.adfaure.services.gnome;
in {
  options.environment.adfaure.services.gnome = {
    enable = mkEnableOption "gnome";
  };

  config = mkIf cfg.enable {
    # Enable the GNOME Desktop Environment.
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;

    environment.systemPackages = with pkgs; [
    ];
  };
}
