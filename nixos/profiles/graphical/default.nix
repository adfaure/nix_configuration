{
  config,
  pkgs,
  lib,
  pi3blocksi3blockskgs,
  ...
}: let
	sddm-theme-chili = pkgs.stdenv.mkDerivation rec {
    name = "sddm-chili";

    src = pkgs.fetchFromGitHub {
      owner = "MarianArlt";
      repo = name;
      rev = "6516d50176c3b34df29003726ef9708813d06271";
      sha256 = "sha256-wxWsdRGC59YzDcSopDRzxg8TfjjmA3LHrdWjepTuzgw=";
    };

    installPhase = ''
      mkdir $out/share/sddm/themes/${name} -p
      cp ${src}/* $out/share/sddm/themes/${name}/. -aR
    '';

    meta = with lib; {
      description = "Theme for SDDM";
      homepage = "https://github.com/MarianArlt/sddm-chili";
      license = licenses.gpl3Only;
      maintainers = with maintainers; [ dan4ik605743 ];
      platforms = platforms.linux;
    };
  };
in
  with lib; {
    imports = [
      ./packages_list.nix
      ../../services/sway
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
      displayManager.sddm = {
        enable = true;
        theme = "sddm-chili";
        enableHidpi = true;
      };

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

    environment.systemPackages = with pkgs; [
      # SDDM Theme
      libsForQt5.plasma-framework
      libsForQt5.qt5.qtgraphicaleffects
      sddm-theme-chili
    ];

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
