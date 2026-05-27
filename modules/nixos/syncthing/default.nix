{ lib, ... }: {
  config,
  ...
}:
with lib; let
  cfg = config.nixosModules.syncthing;
in {
  options.nixosModules.syncthing = {
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
