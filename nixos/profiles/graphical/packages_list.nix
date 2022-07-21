{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.environment.adfaure.environments.graphical = {
    enable = mkEnableOption "graphical";
  };

  config = mkIf config.environment.adfaure.environments.graphical.enable {
    environment.systemPackages = with pkgs; [
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
      tdesktop
      liferea
      # Display my wallpaper
      feh
      autorandr
      # Media
      vlc
      # Utils
      xorg.xkill
      llpp

      # storage
      ntfs3g
      exfat
      parted
      hdparm
      sysstat
      gsmartcontrol
      linuxPackages.perf

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

      # franz
      flameshot
      # pinentry_qt4
    ];
  };
}
