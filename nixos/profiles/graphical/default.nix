{ config, pkgs, lib, pi3blocksi3blockskgs, ... }:
with lib; {

  require = [ ./packages_list.nix ];

  environment.adfaure.environments.graphical.enable = true;
  environment.adfaure.services.i3.enable = true;
  environment.adfaure.services.i3.extraI3Conf = ''
    exec feh --bg-scale '${./wallpapers/totoro.jpg}'
  '';

  # environment.adfaure.programs.emacs.enable=true;
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
      resolutions = [{
        x = 1920;
        y = 1080;
      }];
      libinput.enable = true;
    };
  };

  # Add Workaround for USB 3 Scanner for SANE
  # See http://sane-project.org/ Note 3
  environment.variables.SANE_USB_WORKAROUND = "1";
}
