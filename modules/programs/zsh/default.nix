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

      interactiveShellInit = ''
        imagprint() {
          lp -h print.imag.fr:631 -d lig-copieur-439-nb $1
      }

      '';

      ohMyZsh = {
        enable = true;
        plugins = [ "git" "colored-man-pages" "command-not-found" ];
        theme = "norm";
      };

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

