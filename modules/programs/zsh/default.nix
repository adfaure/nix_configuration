{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.environment.adfaure.programs.zsh;
in
{

  options.environment.adfaure.programs.zsh = {
    enable = mkEnableOption "zsh";
  };

  config = mkIf config.environment.adfaure.programs.zsh.enable {

    programs.zsh = {
      enable = true;
      enableCompletion = true;

      autosuggestions = {
        enable = true;
      };

      shellAliases = {
        r = "ranger";
        vim = "v";
      };

      ohMyZsh = {
        enable = true;
        theme = "norm";
        plugins = [ "git" "command-not-found" "tig" ];
      };

      interactiveShellInit = ''
        source "${builtins.toPath ./zshrc.local}"
      '';
    };

    environment.systemPackages = [
      pkgs.nix-zsh-completions
      pkgs.fasd
      pkgs.zsh-completions
      pkgs.zsh-navigation-tools
      pkgs.tig
      #adfaurePkgs.direnv
    ];

  };
}

