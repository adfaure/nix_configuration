# Edit this configuration file to define what should be installed on your
# system.  Help is available in the configuration.nix(5) man page and in the
# NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  options,
  modulesPath,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-gouttelette.nix
    # syncthings
    ../nixos/services/syncthing
    # We want flake activated
    ../nixos/modules/flakes
    # Cadvisor
    ../nixos/modules/monitoring
    # Default linux configuration: users, fonts etc
    ../nixos/profiles/common
    # Server X configuration, also activate i3
    ../nixos/profiles/graphical
    # Configure cachix
    ../nixos/modules/cachix
  ];

  environment.adfaure.services.syncthing.enable = true;
  services.blueman.enable = true;

  # Use the systemd-boot EFI boot loader.
  systemd.enableUnifiedCgroupHierarchy = false;
  hardware.opengl.driSupport32Bit = true;

  networking = {
    hostName = "gouttelette"; # Define your hostname.
    # resolvconf.enable = true;
    # If using dhcpcd:
    # dhcpcd.extraConfig = "nohook resolv.conf";
    # If using NetworkManager:
    networkmanager.enable = true;
    # networkmanager.dns = "default";
    # networkmanager.insertNameservers = [ "8.8.8.8" "8.8.4.4" ];
  };

  time.timeZone = "Europe/Paris";

  # Add virtualbox and docker
  virtualisation = {docker.enable = true;};

  programs.openvpn3.enable = true;

  programs.dconf.enable = true;
  services.dbus.packages = [pkgs.dconf];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-aad2cd48-0d64-4a51-b371-75180eee1081".device = "/dev/disk/by-uuid/aad2cd48-0d64-4a51-b371-75180eee1081";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "23.11"; # Did you read the comment?
}


