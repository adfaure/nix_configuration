{ config, lib, pkgs, ... }:
let

  # pkgs_lists = import ../config/my_pkgs_list.nix { inherit pkgs; };
  # my_users = import ../config/my_users.nix { inherit pkgs; };

  cfg = config.environment.adfaure.headless;

in

with lib;
{
  options.environment.adfaure.headless = {
    enable = mkEnableOption "headless";
    keys = mkOption {
        type = types.listOf types.string;
        default = [];
        example = [];
        description = ''
          The list of Ssh keys allowed to log.
        '';
    };
  };

  config = mkIf config.environment.adfaure.headless.enable {

    # environment.systemPackages = pkgs_lists.headless;
    environment.adfaure.programs.zsh.enable=true;
    environment.adfaure.programs.vim.enable=true;
    environment.adfaure.programs.ranger.enable=true;
    environment.adfaure.programs.lorri.enable=true;
    environment.adfaure.environments.headless.enable=true;

    # use Vim by default
    environment.shellAliases = {
       "vim"="v";
       "t"="task";
       "tls" = "task ls";
    };

    services.cron = {
      enable = true;
      # systemCronJobs = with backup_tasks_cron; [
      #   "*/5 * * * *      adfaure ${backup_tasks_cron} >> /tmp/cron.log  2>&1"
      # ];
    };
    # Select internationalisation properties.
    console.font = "PowerLine";
    console.keyMap = "fr";

    i18n = {
      defaultLocale = "en_US.UTF-8";
    };

    programs = {
    # Enable system wide zsh and ssh agent
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
      # Start ssh agent
      # ssh.startAgent = true;
      mtr.enable = true;
      gnupg.agent = { enable = true; enableSSHSupport= true; pinentryFlavor = "gtk2"; };
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

    # Get ctrl+arrows works in nix-shell bash
    # environment.etc."inputrc".text = builtins.readFile <nixpkgs/nixos/modules/programs/bash/inputrc> + ''
    #   "\e[A": history-search-backward
    #   "\e[B": history-search-forward
    #   set completion-ignore-case on
    # '';

    users.extraUsers.adfaure = {
      isNormalUser = true;
      home = "/home/adfaure";
      shell = pkgs.zsh;
      extraGroups = [ "audio" "wheel" "networkmanager" "vboxusers" "lp" ];
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
        penultimate.enable = true;
        defaultFonts = {
          monospace = ["Fira Mono"];
          sansSerif = ["Fira Sans"];
          serif = ["DejaVu Serif"];
        };
      };

      fonts = with pkgs; [
        # nerdfonts
        emojione
        # noto-fonts
        # noto-fonts-cjk
        # noto-fonts-emoji
        liberation_ttf
        fira-code-symbols
        mplus-outline-fonts
        dina-font
        proggyfonts
        fira-code
        fira-mono
        # noto-fonts
        # noto-fonts-emoji
        font-awesome_5
        font-awesome_4
        hasklig
        wqy_zenhei
      ];
    };
    # services.cron.enable = true;
    services.keybase.enable = true;
    documentation.dev.enable = true;
  };
}
