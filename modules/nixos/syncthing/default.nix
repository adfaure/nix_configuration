{
  config,
  lib,
  pkgs,
  my-dotfiles,
  ...
}:
with lib; let
  cfg = config.adfaure.services.syncthing;
in {
  options.adfaure.services.syncthing = {
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
