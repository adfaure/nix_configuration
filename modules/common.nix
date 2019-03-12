{ config, lib, pkgs, ... }:
let

  pkgs_lists = import ../config/my_pkgs_list.nix { inherit pkgs; };
  my_users = import ../config/my_users.nix { inherit pkgs; };
  cfg = config.environment.adfaure.common;

in

with lib;

{
  options.environment.adfaure.common = {
    enable = mkEnableOption "common";
    keys = mkOption {
        type = types.listOf types.string;
        default = [];
        example = [];
        description = ''
          The list of Ssh keys allowed to log.
        '';
    };
  };

  config = mkIf config.environment.adfaure.common.enable {

    environment.systemPackages = pkgs_lists.common;

    # use Vim by default
    environment.sessionVariables.EDITOR="v";
    environment.sessionVariables.VISUAL="v";
    environment.shellAliases = {
      "vim"="v";
    };


    # Select internationalisation properties.
    i18n = {
      consoleFont = "Lat2-Terminus16";
      consoleKeyMap = "fr";
      defaultLocale = "fr_FR.UTF-8";
    };

    programs = {
    # Enable system wide zsh and ssh agent
      zsh.enable = true;
      # ssh.startAgent = true;

      zsh.enableCompletion = true;
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
      gnupg.agent = { enable = true; enableSSHSupport= true; };

      # Whether interactive shells should show which Nix package (if any)
      # provides a missing command.
      command-not-found.enable = true;
    };

    # Make sudo funnier!
    security.sudo.extraConfig = ''
        Defaults   insults
    '';

    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.packageOverrides = pkgs:
    {
      sudo = pkgs.sudo.override { withInsults = true; };
    };

    # Get ctrl+arrows works in nix-shell bash
    environment.etc."inputrc".text = builtins.readFile <nixpkgs/nixos/modules/programs/bash/inputrc> + ''
      "\e[A": history-search-backward
      "\e[B": history-search-forward
      set completion-ignore-case on
    '';

    # Add my user
    users.extraUsers = {
      adfaure = my_users.adfaure;
    };

    services.cron.enable = true;

  };
}
