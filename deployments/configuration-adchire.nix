# Edit this configuration file to define what should be installed on your
# system.  Help is available in the configuration.nix(5) man page and in the
# NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, lib, options, modulesPath }: {

  imports = [ # Include the results of the hardware scan.
    ./hardware-adchire.nix
    # I3 and conf
    ../nixos/services/i3
    # We want flake activated
    ../nixos/modules/flakes
    # Default linux configuration: users, fonts etc
    ../nixos/profiles/common
    # Server X configuration, also activate i3
    ../nixos/profiles/graphical
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.opengl.driSupport32Bit = true;

  networking = {
    hostName = "adchire"; # Define your hostname.
    resolvconf.enable = true;
    # If using dhcpcd:
    dhcpcd.extraConfig = "nohook resolv.conf";
    # If using NetworkManager:
    networkmanager.enable = true;
    networkmanager.dns = "default";
    networkmanager.insertNameservers = [ "8.8.8.8" "8.8.4.4" ];
  };

  time.timeZone = "Europe/Paris";

  # Add virtualbox and docker
  virtualisation = { docker.enable = true; };

  system.autoUpgrade.enable = true;
  system.autoUpgrade.channel = "https://nixos.org/channels/unstable";

  system.stateVersion = "20.09";

  programs.dconf.enable = true;
  services.dbus.packages = [ pkgs.gnome3.dconf ];
}
