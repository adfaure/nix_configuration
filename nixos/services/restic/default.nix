{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.adfaure.modules.restic-conf;
in {

  options.adfaure.modules.restic-conf = {
    enable = lib.mkEnableOption "restic-conf";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.restic
    ];

    services.restic.backups = {
      localbackup = {
        exclude = [
          "/home/*/.cache"
        ];
        initialize = true;
        passwordFile = "/home/adfaure/Code/backups/secret";

        paths = [
          "/home/adfaure/Sync"
        ];

        repository = "/home/adfaure/Code/backups/nixos-repository";
      };
    };
  };
}
