{
  lib,
  config,
  pkgs,
  private,
  ...
}:
let
  cfg = config.adfaure.services.restic-conf;
in {

  options.adfaure.services.restic-conf = {
    enable = lib.mkEnableOption "restic-conf";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.restic
    ];

    services.restic.backups = let
      backup_config = "/home/adfaure/Code/backups";
    in
     {
      localbackup = {
        user = "adfaure";
        initialize = true;
        dynamicFilesFrom = "cat ${backup_config}/paths";
        passwordFile = "${backup_config}/secret";
        repository = "${backup_config}/restic-repository";
        timerConfig = {
          OnCalendar = "17:33";
          Persistent = true;
        };
      };
    };
  };
}
