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
    ./hardware-altitude.nix
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

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  boot.initrd.luks.devices."luks-0e79e02e-e770-4acc-8986-360e1a77f270".device = "/dev/disk/by-uuid/0e79e02e-e770-4acc-8986-360e1a77f270";
  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  boot.loader.grub.enableCryptodisk = true;

  boot.initrd.luks.devices."luks-e7e0cf9a-e269-401f-a22c-1794f9901e60".keyFile = "/crypto_keyfile.bin";
  boot.initrd.luks.devices."luks-0e79e02e-e770-4acc-8986-360e1a77f270".keyFile = "/crypto_keyfile.bin";

  networking = {
    hostName = "altitude"; # Define your hostname.
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

  programs.openvpn3.enable = true;

  programs.dconf.enable = true;
  services.dbus.packages = [pkgs.dconf];
}
