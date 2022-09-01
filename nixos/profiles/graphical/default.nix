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
    ];

    environment.adfaure.environments.graphical.enable = true;
    environment.adfaure.services.sway.enable = true;

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
      pulse.enable = true;
    };

    services.xserver = {
      enable = true;
      displayManager.sddm.enable = true;
      layout = "fr";
      # xkbVariant = "bepo";
      resolutions = [
        {
          x = 2560;
          y = 1440;
        }
        {
          x = 1920;
          y = 1080;
        }
      ];
      libinput.enable = true;
    };

    services.dbus.enable = true;

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      # gtk portal needed to make gtk apps happy
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
      gtkUsePortal = true;
    };

    programs.adb.enable = true;
    users.users.adfaure.extraGroups = ["adbusers"];
  }
