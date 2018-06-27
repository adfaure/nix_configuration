# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
let

in
let

  mypkgs = import /home/adfaure/Projects/myPkgs { };
  my_dotfiles = builtins.fetchTarball "https://github.com/adfaure/dotfiles/archive/master.tar.gz";

in rec {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #taken from: https://github.com/ttuegel/nixos-config/blob/207f14e40489835801e2bdb572ded43e58f7f80d/programs/emacs.nix
      ./my_emacs.nix
      ./modipy.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "adchire"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "fr";
    defaultLocale = "fr_FR.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wget
    vim
    emacs
    git
    sakura
    tmux
    firefox
    ranger
    tdesktop
    zsh
    pass
    nox
    ctags
    (callPackage ./my_vim.nix {})
    ((pkgs.callPackage ./pkgs/nix-home.nix) {})
    mopidy
    spotify
    htop
    unrar
    file
    tree
    ncdu
    libcaca   # video
    highlight # code
    atool     # archives
    w3m       # web
    poppler   # PDF
    mediainfo # audio and video   
    jq
    aspellDicts.fr
    aspellDicts.en
    gnome3.polari
    vlc
    xorg.xkill
    git-cola
    cmake
    inkscape    
    fortune
    cups # Print utilities (lp) 
    stress
    gcc
    gnumake
    psmisc
    # latex
    rubber
    rambox
    biber
    texlive.combined.scheme-full
    virtualbox
    qemu
    arandr
    unzip
    zip
    screen-message
    pdftk
    chromium
    dia
    pciutils
    pandoc
    texmaker    
    direnv
    nixops
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  # use Vim by default
  environment.sessionVariables.EDITOR="v";
  environment.sessionVariables.VISUAL="v";
  environment.shellAliases = {
    "vim"="v";
  };

  programs = {
    # Enable system wide zsh and ssh agent
    zsh.enable = true;
    # ssh.startAgent = true;

    bash = {
      enableCompletion = true;
      # Make shell history shared and saved at each command
      interactiveShellInit = ''
        shopt -s histappend
        PROMPT_COMMAND="history -n; history -a"
        unset HISTFILESIZE
        HISTSIZE=5000
        '';
      };

    mtr.enable = true;
    gnupg.agent = { enable = true; enableSSHSupport = true; };

    command-not-found.enable = true;
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;
  # Enable the X11 windowing system.
  services.xserver = {
      enable = true;
      layout = "fr";
      xkbOptions = "eurosign:e";
      libinput.enable = true;
      # Enable the Gnome Desktop Environment.
      desktopManager.gnome3.enable = true;
      displayManager.gdm.enable = true;

      #
      # windowManager.default = "i3";
      # windowManager.i3.enable = true;
  };

  hardware.opengl.driSupport32Bit = true;
  # services.gnome3.evolution-data-server.enable = lib.mkForce false;  

  # enable thefuck!
  programs.thefuck.enable = false;

  # enable cron table
  services.cron.enable = true;

  nixpkgs.config.allowUnfree = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.adfaure = {
    isNormalUser = true;
    home = "/home/adfaure";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" ];
    uid = 1000;
  };

  # Add virtualbox and docker
  virtualisation = {
    virtualbox.host.enable = true;
    docker.enable = true;
  };

  system.autoUpgrade.enable = true;
  system.autoUpgrade.channel = https://nixos.org/channels/nixos-18.03;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?
  # Try fix chrome extension error
  services.dbus.socketActivated = true;
  services.xserver.desktopManager.gnome3.sessionPath = [
    pkgs.json_glib
    pkgs.glib_networking
    pkgs.libgtop ];
}
