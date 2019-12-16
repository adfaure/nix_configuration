{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.environment.adfaure.programs.ranger;
in
  {
    options.environment.adfaure.programs.ranger = {
      enable = mkEnableOption "ranger";
    };
    config = mkIf cfg.enable {
      environment.systemPackages = [
        pkgs.ranger
        pkgs.atool
        pkgs.poppler_utils
        # pdf reader
        pkgs.zathura
      ];

      environment.shellAliases = {
        ranger = "ranger --confdir=${builtins.toPath ./ranger}";
      };

      programs.zsh.interactiveShellInit = lib.mkAfter ''
      # Add ctrl+N shortcut to navigate with ranger and zsh
      _ranger () {
      PYTHONPATH= command ${pkgs.ranger}/bin/ranger --confdir=${builtins.toPath ./ranger} "$(pwd)"<$TTY
      print -n "\033[A"
      zle && zle -I
      cd "$(grep \^\' ${builtins.toPath ./ranger}/bookmarks | cut -b3-)"
      }

      zle -N _ranger
      bindkey -v '^N' _ranger
      '';
    };
  }
