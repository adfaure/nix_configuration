{
  config,
  pkgs,
  lib,
  my-dotfiles,
  ...
}:
with lib; {
  imports = [
    ../../services/sway
    ../../services/gnome
    ../../services/plasma
    ../../services/hyprland
  ];

  adfaure.services.gnome.enable = true;
  adfaure.services.plasma.enable = false;
  adfaure.services.sway.enable = false;
  adfaure.services.hyprland.enable = false;

  programs.light.enable = true;

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

  hardware.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.dbus.enable = true;

  programs.adb.enable = true;
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
    # Utils
    xorg.xkill
    # llpp

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

    pinentry-qt
  ];
}
