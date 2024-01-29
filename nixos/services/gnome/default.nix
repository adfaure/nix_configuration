{
  config,
  lib,
  pkgs,
  my-dotfiles,
  ...
}:
with lib; let
  cfg = config.environment.adfaure.services.gnome;
  waybar-with-conf =
    pkgs.writeShellScriptBin
    "waybar-with-conf"
    "${waybar-media}/bin/waybar --config ${my-dotfiles}/files/waybar/config --style ${my-dotfiles}/files/waybar/style.css";
in {
  options.environment.adfaure.services.gnome = {
    enable = mkEnableOption "gnome";
  };

  config = mkIf cfg.enable {

    # Enable the GNOME Desktop Environment.
    services.xserver.displayManager.gdm.wayland = true;
    services.gnome.gnome-keyring.enable = true;

    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;

    environment.systemPackages = with pkgs; [
      gnomeExtensions.system-monitor-next
      gnomeExtensions.battery-health-charging
      gnomeExtensions.steal-my-focus-window
      polkit
      polkit_gnome
      gnome.dconf-editor
    ];

    environment.gnome.excludePackages =
      (with pkgs; [
        gnome-photos
        gnome-tour
      ])
      ++ (with pkgs.gnome; [
        cheese # webcam tool
        gnome-music
        gnome-terminal
        gedit # text editor
        epiphany # web browser
        geary # email reader
        evince # document viewer
        gnome-characters
        totem # video player
        tali # poker game
        iagno # go game
        hitori # sudoku game
        atomix # puzzle game
      ]);

    programs.dconf.enable = true;
  };
}
