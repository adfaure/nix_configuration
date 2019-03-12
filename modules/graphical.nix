{ config, lib, pkgs, ... }:
let
  pkgs_lists = import ../config/my_pkgs_list.nix { inherit pkgs; };
  cfg = config.environment.adfaure.graphical;
in
  with lib;
  {
    options.environment.adfaure.graphical = {
      enable = mkEnableOption "graphical";
      keys = mkOption {
        type = types.listOf types.string;
        default = [];
        example = [];
        description = ''
          The list of Ssh keys allowed to log.
        '';
      };
    };

    config = mkIf config.environment.adfaure.graphical.enable {
      environment.systemPackages = pkgs_lists.graphical;

     programs.light.enable = true;
      services = {

        # Install but disable open SSH
        openssh = {
          enable = false;
          permitRootLogin = "false";
        };

        redshift = {
          enable = false; 
          provider = "geoclue2";
        };

        # Enable CUPS to print documents.
        printing = {
          enable = true;
          browsing = true;
          drivers = [ pkgs.samsung-unified-linux-driver ];
        };
        # Needed for printer discovery
        avahi.enable = true;
        avahi.nssmdns = true;

        xserver = {
          enable = true;
          layout = "fr";
          xkbVariant = "bepo";
          libinput.enable = true;
          # Enable the Gnome Desktop Environment.
          # desktopManager.gnome3.enable = true;
          # displayManager.gdm.enable = true;

          windowManager.i3.enable = true;
          windowManager.default = "i3";
          # displayManager.gdm.enable = true;

          # desktopManager = {
          #  default = "xfce";
          #  xterm.enable = false;
          #  xfce.enable = true;
          #};

          # windowManager.default = "i3";
          # windowManager.i3.enable = true;
        };

        clamav.updater.enable = true;

      };

      # Make fonts better...
      fonts.fontconfig = {
        enable = true;
        ultimate.enable = true;
      };
      # Add micro$oft fonts
      fonts.fonts = [ pkgs.corefonts ];
      # Add Workaround for USB 3 Scanner for SANE
      # See http://sane-project.org/ Note 3
      environment.variables.SANE_USB_WORKAROUND = "1";
    };
  }
