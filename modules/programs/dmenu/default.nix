{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.environment.adfaure.programs.zsh;
in
{

  options.environment.adfaure.programs.dmenu = {
    enable = mkEnableOption "dmenu";
  };

  config = mkIf config.environment.adfaure.programs.zsh.enable {

    environment.systemPackages = [
      dmenu
      xorg.setxkbmap
      python3
      which
    ];

  };
}

