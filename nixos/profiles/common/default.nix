{ config, lib, pkgs, ... }:
with lib; {

  require = [ ./package_list.nix ];

  # This option enables the import of the package defined in `package_list.nix`
  # in the system environment.
  environment.adfaure.environments.headless.enable = true;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # use Vim by default
  environment.shellAliases = {
    "vim" = "v";
    "t" = "task";
    "tls" = "task ls";
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
      enableSSHSupport = true;
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

  nixpkgs.config = {
    pulseaudio = true;
    allowUnfree = true;
    firefox.enableBrowserpass = true;
    packageOverrides = pkgs: {
      sudo = pkgs.sudo.override { withInsults = true; };
    };
  };

  nix.trustedUsers = [ "root" "adfaure" ];
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
    openssh.authorizedKeys.keys =
      [ (lib.readFile ../../../deployments/keys/id_rsa.pub) ];
    # Set the initial password. Don't forget to change it ASAP.
    initialPassword = "nixos";
    uid = 1000;
  };

  i18n = { defaultLocale = "en_US.UTF-8"; };

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
        monospace = [ "Fira Mono" ];
        sansSerif = [ "Fira Sans" ];
        serif = [ "DejaVu Serif" ];
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
