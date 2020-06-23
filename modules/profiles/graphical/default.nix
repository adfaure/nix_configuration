{ config, lib, pkgs, ... }:
let
  # pkgs_lists = import ../config/my_pkgs_list.nix { inherit pkgs; };
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
      environment.adfaure.environments.graphical.enable=true;
      environment.adfaure.services.i3.enable=true;
      environment.adfaure.services.i3.extraI3Conf= ''
        exec feh --bg-scale '${./wallpapers/totoro.jpg}'
      '';

      environment.adfaure.programs.emacs.enable=true;
      programs.light.enable = true;

      services = {
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
          resolutions =  [ {x = 1920; y = 1080;} ];
          libinput.enable = true;
          # Enable the Gnome Desktop Environment.
          # desktopManager.gnome3.enable = true;
          # displayManager.sddm.enable = true;
          # displayManager.defaultSession = "none+i3";
          # desktopManager = {
          #  default = "none";
          #  xterm.enable = false;
          #};
        };

       #clamav.updater.enable = true;
     };

     # Add Workaround for USB 3 Scanner for SANE
     # See http://sane-project.org/ Note 3
     environment.variables.SANE_USB_WORKAROUND = "1";
  };
}
