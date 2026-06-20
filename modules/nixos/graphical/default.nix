{lib, ...}: {
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.nixosModules.graphical;
in {
  options.nixosModules.graphical = {
    enable = mkEnableOption "graphical";
    desktopEnvironment = mkOption {
      type = types.enum [ "gnome" "niri" ];
      default = "gnome";
    };
  };

  config = mkIf cfg.enable {

    # Select a desktop environment
    nixosModules.gnome.enable = cfg.desktopEnvironment == "gnome";
    nixosModules.niri.enable = cfg.desktopEnvironment == "niri";

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = false;
      dedicatedServer.openFirewall = false;
    };

    services = {
      # Enable CUPS to print documents.
      printing = {
        enable = true;
        browsing = true;
        drivers = [pkgs.samsung-unified-linux-driver];
      };

      # Needed for printer discovery
      avahi.enable = true;
      avahi.nssmdns4 = true;
    };

    # hardware.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # TODO: should we enable that ?
    # security.rtkit.enable = true;
    services.dbus.enable = true;
    users.users.adfaure.extraGroups = ["adbusers"];

    environment.systemPackages = with pkgs; [
      wl-clipboard
      # For system Monitor plugin
      gobject-introspection
      libgtop
      json-glib
      glib-networking
      arandr
      # Web
      # firefox
      chromium
      # Dictionnaries
      aspellDicts.fr
      aspellDicts.en
      # Message and RSS
      # tdesktop
      liferea
      # Display my wallpaper
      feh
      autorandr
      # Media
      vlc

      # storage
      ntfs3g
      exfat
      parted
      hdparm
      sysstat
      gsmartcontrol
      perf

      # Password
      gnupg

      # Graphic tools
      gcolor3
      graphviz
      imagemagick
      inkscape
      pavucontrol

      libreoffice
      zotero

      pinentry-qt
    ];
  };
}
