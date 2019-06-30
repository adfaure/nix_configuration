{ config, lib, pkgs, ... }:

with lib;
{
  options.environment.adfaure.environments.graphical = {
    enable = mkEnableOption "graphical";
  };

  config = mkIf config.environment.adfaure.environments.graphical.enable {
    environment.systemPackages = with pkgs; [
      # For system Monitor plugin
      gobjectIntrospection
      libgtop
      json_glib
      glib_networking
      chrome-gnome-shell
      arandr

      # Web
      firefox
      chromium
      # Dictionnaries
      aspellDicts.fr
      aspellDicts.en
      # Message and RSS
      #qtox
      #tdesktop
      liferea

      # Media
      vlc
      # Utils
      xorg.xkill
      # wireshark-gtk
      git-cola
      gitg
      sakura
      evince

      # storage
      ntfs3g
      exfat
      parted
      hdparm
      sysstat
      gsmartcontrol
      linuxPackages.perf
      spotify
      # Password
      gnupg

      virtualbox

      # Graphic tools
      gcolor3
      graphviz
      imagemagick
      inkscape
      sublime3
      pavucontrol

      rambox
      godot
      libreoffice
    ];
  };
}

