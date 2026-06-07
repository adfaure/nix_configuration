{lib, ...}: {
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.nixosModules.minimal;
in {
  options.nixosModules.minimal = {
    enable = mkEnableOption "minimal";
  };

  config = mkIf cfg.enable {
    # use Vim by default
    environment.shellAliases = {
      "vim" = "vim";
      "t" = "task";
      "tls" = "task ls";
    };
    time.timeZone = "Europe/Paris";
    services.printing.enable = true;
    services.blueman.enable = true;
    networking.networkmanager.enable = true;

    environment.variables = {
      LC_ALL = "en_US.UTF-8";
    };

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "fr_FR.UTF-8";
      LC_IDENTIFICATION = "fr_FR.UTF-8";
      LC_MEASUREMENT = "fr_FR.UTF-8";
      LC_MONETARY = "fr_FR.UTF-8";
      LC_NAME = "fr_FR.UTF-8";
      LC_NUMERIC = "fr_FR.UTF-8";
      LC_PAPER = "fr_FR.UTF-8";
      LC_TELEPHONE = "fr_FR.UTF-8";
      LC_TIME = "fr_FR.UTF-8";
    };

    nix.settings.trusted-users = ["root" "adfaure"];

    programs = {
      gnupg.agent = {
        enable = true;
        # pinentryFlavor = "qt";
        enableSSHSupport = true;
      };

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

    fonts = {
      # fontDir.enable = true;
      # enableGhostscriptFonts = true;
      fontconfig = {
        enable = true;
        allowBitmaps = true;
        useEmbeddedBitmaps = true;
      };

      packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        # noto-fonts-emoji  # removed in 15.11
        liberation_ttf
        fira-code
        fira-code-symbols
        mplus-outline-fonts.githubRelease
        dina-font
        proggyfonts
      ];
    };

    services.pcscd.enable = true;
    services.sshd.enable = false;

    documentation.dev.enable = true;

    services.devmon.enable = true;
    services.gvfs.enable = true;
    services.udisks2.enable = true;

    environment.systemPackages = with pkgs; [
      # monitoring
      psmisc
      pmutils
      nmap
      htop
      polkit
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
  };
}
