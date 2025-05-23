{
  lib,
  pkgs,
  ...
}: {
  imports = [
    # syncthings
    ../../services/syncthing
    # We want flake activated
    ../../modules/flakes
    # Configure cachix
    ../../modules/cachix
    # Simple guix module with guix sevice enabled and package added to env
    ../../modules/guix
    ../../modules/vm
  ];

  adfaure.modules.my-guix.enable = true;
  adfaure.modules.vm.enable = true;
  adfaure.services.syncthing.enable = true;

  # use Vim by default
  environment.shellAliases = {
    "vim" = "vim";
    "t" = "task";
    "tls" = "task ls";
  };

  programs = {
    zsh.enable = true;
    bash = {
      completion.enable = true;
      # Make shell history shared and saved at each command
      interactiveShellInit = ''
        shopt -s histappend
        PROMPT_COMMAND="history -n; history -a"
        unset HISTFILESIZE
        HISTSIZE=5000
      '';
    };
    mtr.enable = true;

    gnupg.agent = {
      enable = true;
      # pinentryFlavor = "qt";
      enableSSHSupport = true;
    };

    # Whether interactive shells should show which Nix package (if any)
    # provides a missing command.
    command-not-found.enable = true;
    nm-applet.enable = true;
  };

  # Make sudo funnier!
  security.sudo.extraConfig = ''
    Defaults   insults
  '';

  nixpkgs.config = {
    pulseaudio = true;
    allowUnfree = true;
    # firefox.enableBrowserpass = true;
    firefox.nativeMessagingHosts = true;
    packageOverrides = pkgs: {
      sudo = pkgs.sudo.override {withInsults = true;};
    };
  };

  nix.settings.trusted-users = ["root" "adfaure"];

  users.extraUsers.adfaure = {
    isNormalUser = true;
    home = "/home/adfaure";
    shell = pkgs.zsh;
    extraGroups = [
      "audio"
      "wheel"
      "networkmanager"
      "vboxusers"
      "lp"
      "perf_users"
      "docker"
      "users"
    ];
    openssh.authorizedKeys.keys = [(lib.readFile ../../../nixos/deployments/keys/id_rsa.pub)];
    # Set the initial password. Don't forget to change it ASAP.
    initialPassword = "nixos";
    uid = 1000;
  };

  environment.variables = {
    LC_ALL = "en_US.UTF-8";
  };

  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fontconfig = {
      enable = true;
      allowBitmaps = true;
      antialias = true;
      hinting.enable = true;
      includeUserConf = true;
      defaultFonts = {
        monospace = ["Fira Mono"];
        sansSerif = ["Fira Sans"];
        serif = ["DejaVu Serif"];
      };
    };

    packages = with pkgs; [
      font-awesome_5
      iosevka-bin
      iosevka

      emojione
      liberation_ttf
      fira-code-symbols
      dina-font
      proggyfonts
      fira-code
      fira-mono
      hasklig
      wqy_zenhei
      roboto
      roboto-slab
      roboto-mono
      roboto-serif
    ];
  };

  services.pcscd.enable = true;

  services.sshd.enable = true;
  services.keybase.enable = true;
  documentation.dev.enable = true;

  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  programs.singularity.enable = true;
  programs.singularity.enableFakeroot = true;

  environment.systemPackages = with pkgs; [
    # monitoring
    psmisc
    pmutils
    nmap
    htop
    # tools
    tmux
    libcaca # video
    highlight # code
    atool # archives
    w3m # web
    poppler # PDF
    mediainfo # audio and video
    pinentry-curses
    restic
  ];
}
