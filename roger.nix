# Edit this configuration file to define what should be installed on your
# system.  Help is available in the configuration.nix(5) man page and in the
# NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, lib, ... }:
let
  lorri = import (fetchTarball {
    url = https://github.com/target/lorri/archive/rolling-release.tar.gz;
  }) {};
  # mypkgs = import /home/adfaure/Projects/myPkgs { };
  my_dotfiles = builtins.fetchTarball "https://github.com/adfaure/dotfiles/archive/master.tar.gz";
  # modules = import ../modules/module-list.nix;
in rec {

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-roger.nix
    ];

  # require = modules;

  environment.adfaure.graphical.enable = true;
  environment.adfaure.headless.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "roger"; # Define your hostname.
    resolvconf.enable = true;
    # If using dhcpcd:
    dhcpcd.extraConfig = "nohook resolv.conf";
    # If using NetworkManager:
    networkmanager.enable = true;
    networkmanager.dns = "default";
    # Alternative DNS to be able to reach sci- ... hmm nevermind :)
    networkmanager.insertNameservers = [ "8.8.8.8" "8.8.4.4" ];
  };
  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [ lorri ];

  hardware.opengl.driSupport32Bit = true;
  # services.gnome3.evolution-data-server.enable = lib.mkForce false;

  # enable cron table
  services.cron.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
    pulseaudio = true;
  };

  # Add virtualbox and docker
  virtualisation = {
    # virtualbox.guest.enable = true;
    # virtualbox.host.enable = true;
    docker.enable = true;
  };

  system.autoUpgrade.enable = true;
  system.autoUpgrade.channel = https://nixos.org/channels/unstable;
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.

  # environment.etc = {
  #   "resolv.conf".text = "nameserver 80.82.77.83\n";
  # };


  system.stateVersion = "20.09"; # Did you read the comment?

  services.dbus.socketActivated = true;
  programs.dconf.enable = true;
  services.dbus.packages = [ pkgs.gnome3.dconf ];
}
