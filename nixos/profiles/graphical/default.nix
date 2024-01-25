{
  config,
  pkgs,
  lib,
  pi3blocksi3blockskgs,
  ...
}: let

in
  with lib; {
    imports = [
      ./packages_list.nix
      ../../services/sway
      ../../services/gnome
    ];

    environment.adfaure.environments.graphical.enable = true;
    environment.adfaure.services.gnome.enable = true;

    # environment.adfaure.programs.emacs.enable=true;
    programs.light.enable = true;

    services = {
      # Enable CUPS to print documents.
      printing = {
        enable = true;
        browsing = true;
        drivers = [pkgs.samsung-unified-linux-driver];
      };

      # Needed for printer discovery
      avahi.enable = true;
      avahi.nssmdns = true;
    };

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    services.dbus.enable = true;

    # xdg.portal = {
    #   enable = true;
    #   wlr.enable = true;
    #   # gtk portal needed to make gtk apps happy
    #   extraPortals = [pkgs.xdg-desktop-portal-gtk];
    #   gtkUsePortal = true;
    # };

    programs.adb.enable = true;
    users.users.adfaure.extraGroups = ["adbusers"];
  }
