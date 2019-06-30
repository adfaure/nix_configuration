# Edit this configuration file to define what should be installed on your
# system.  Help is available in the configuration.nix(5) man page and in the
# NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
let

in
let

  mypkgs = import /home/adfaure/Projects/myPkgs { };
  my_dotfiles = builtins.fetchTarball
  "https://github.com/adfaure/dotfiles/archive/master.tar.gz";
  modules = import ../modules/module-list.nix;

in rec {

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-adchire.nix
    ];

  require = modules;

  environment.adfaure.graphical.enable = true;
  environment.adfaure.headless.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  networking.networkmanager.enable = true;
  networking.hostName = "adchire"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [];

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
    virtualbox.host.enable = true;
    docker.enable = true;
  };

  system.autoUpgrade.enable = true;
  system.autoUpgrade.channel = https://nixos.org/channels/nixos-19.03;
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.

  system.stateVersion = "19.03"; # Did you read the comment?
  # Try fix chrome extension error

  services.dbus.socketActivated = true;
  programs.dconf.enable = true;
  services.dbus.packages = [ pkgs.gnome3.dconf ];

}
