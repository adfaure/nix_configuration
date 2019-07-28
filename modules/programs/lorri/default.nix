{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.environment.adfaure.programs.lorri;
  lorri = import (fetchTarball {
    url = https://github.com/target/lorri/archive/rolling-release.tar.gz;
  }) {};
in
{
  options.environment.adfaure.programs.lorri = {
    enable = mkEnableOption "lorri";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ lorri pkgs.direnv ];
    programs = {
      bash.interactiveShellInit = ''
        eval "$(${pkgs.direnv}/bin/direnv hook bash)"
      '';
      zsh.interactiveShellInit = ''
        eval "$(${pkgs.direnv}/bin/direnv hook zsh)"
      '';
    };
  };

}
