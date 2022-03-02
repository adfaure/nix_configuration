{ config, pkgs, lib, pi3blocksi3blockskgs, ... }:
with lib; {

  imports = [
    ./packages_list.nix
  ];

  environment.adfaure.environments.graphical.enable = true;
  environment.adfaure.services.i3.enable = true;
  environment.adfaure.services.i3.extraI3Conf = ''
    exec_always --no-startup-id autorandr --change && feh --no-fehbg --bg-scale --randomize "${config.users.extraUsers.adfaure.home}/.wallpapers";
    exec --no-startup-id ${pkgs.blueman}/bin/blueman-applet
  '';

  # environment.adfaure.programs.emacs.enable=true;
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
  };

  programs.adb.enable = true;
  users.users.adfaure.extraGroups = ["adbusers"];

  # Add Workaround for USB 3 Scanner for SANE
  # See http://sane-project.org/ Note 3
  environment.variables.SANE_USB_WORKAROUND = "1";
}
