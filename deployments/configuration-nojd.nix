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
    ./hardware-nojd.nix
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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  hardware.opengl.driSupport32Bit = true;

  networking = {
    hostName = "nojd"; # Define your hostname.
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

  system.autoUpgrade.enable = false;
  system.autoUpgrade.channel = "https://nixos.org/channels/unstable";

  system.stateVersion = "22.05";

  programs.dconf.enable = true;
  services.dbus.packages = [pkgs.dconf];
}
