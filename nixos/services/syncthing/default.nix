{ config, lib, pkgs, my-dotfiles, ... }:
with lib;
let
  cfg = config.environment.adfaure.services.syncthing;
in {
  options.environment.adfaure.services.syncthing = {
    enable = mkEnableOption "syncthing";
  };

  config = mkIf cfg.enable {
      services.syncthing = {
        enable = true;
        group = "users";
        user = "adfaure";
        systemService = true;
        configDir = "${config.users.extraUsers.adfaure.home}/.config/syncthing";
      };
  };
}
