{
  config,
  lib,
  pkgs,
  my-dotfiles,
  ...
}:
with lib; let
  cfg = config.adfaure.services.gnome;
in {
  options.adfaure.services.gnome = {
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
      gnomeExtensions.window-list
      polkit
      polkit_gnome
      dconf-editor
      gnome-tweaks

      # Because I'm curious
      gnomeExtensions.zen
      gnomeExtensions.yakuake
      gnomeExtensions.window-title-is-back
      gnomeExtensions.window-state-manager
      gnomeExtensions.window-list-in-panel
      gnomeExtensions.whoami-in-top-bar
      gnomeExtensions.wayland-or-x11
    ];

    environment.gnome.excludePackages =
      (with pkgs; [
        gnome-photos
        gnome-tour
      ])
      ++ (with pkgs; [
        cheese # webcam tool
        gnome-music
        gnome-terminal
        # gedit # text editor
        epiphany # web browser
        geary # email reader
        # evince # document viewer
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
