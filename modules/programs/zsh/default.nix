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
        v = "vim";
      };

      ohMyZsh = {
        enable = true;
        theme = "norm";
      };

      shellInit = ''
        # source "${builtins.toPath ./zshrc}"
        source "${builtins.toPath ./zshrc.local}"
      '';
    };

    environment.systemPackages = [
      pkgs.nix-zsh-completions
      pkgs.fasd
      pkgs.zsh-completions
      pkgs.zsh-navigation-tools
      #adfaurePkgs.direnv
    ];

  };
}

