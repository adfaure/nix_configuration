{ config, lib, pkgs, ... }:
with lib; {

  # use Vim by default
  environment.shellAliases = {
     "vim"="v";
     "t"="task";
     "tls" = "task ls";
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  programs = {
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
    gnupg.agent = {
      enable = true;
      enableSSHSupport= true;
      # pinentryFlavor = "gtk2";
    };
    # Whether interactive shells should show which Nix package (if any)
    # provides a missing command.
    command-not-found.enable = true;
  };

  # Make sudo funnier!
  security.sudo.extraConfig = ''
      Defaults   insults
  '';

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.firefox.enableBrowserpass = true;
  nixpkgs.config.packageOverrides = pkgs:
  {
    sudo = pkgs.sudo.override { withInsults = true; };
  };

  nix.trustedUsers = [ "root" "adfaure" ];

  users.extraUsers.adfaure = {
    isNormalUser = true;
    home = "/home/adfaure";
    shell = pkgs.zsh;
    extraGroups = [ "audio" "wheel" "networkmanager" "vboxusers" "lp" "perf_users" "docker" "users" ];
    openssh.authorizedKeys.keys = [
        (lib.readFile ../../../deployments/keys/id_rsa.pub)
    ];
    hashedPassword = "$6$1povfYo8YR1SMM$lzpE2aBCGZyNFCE7Nr2pizFyLb4O7jB6IJdvuoGHVziBg2ynRjtz/8hemZPFiYX.9AGbyDoXMGoH6.P6SvQPx/";
    uid = 1000;
  };

  fonts = {
    enableFontDir = true;
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

    fonts = with pkgs; [
      emojione
      liberation_ttf
      fira-code-symbols
      mplus-outline-fonts
      dina-font
      proggyfonts
      fira-code
      fira-mono
      font-awesome_5
      font-awesome_4
      hasklig
      wqy_zenhei
    ];
  };

  services.pcscd.enable = true;
  services.sshd.enable = true;
  services.keybase.enable = true;
  documentation.dev.enable = true;
}
