{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.adfaure.home-modules.user-timers;
in {
  options.adfaure.home-modules.user-timers = {
    enable = mkEnableOption "user-timers";
  };

  config = mkIf cfg.enable {

    systemd.user.services.restic-backup = let
      backup_dir = "/home/adfaure/Code/backups";
    in
    {
      Unit = { Description = "Restic backup"; };
      Service = {
        CPUSchedulingPolicy = "idle";
        IOSchedulingClass = "idle";
        WorkingDirectory = "${backup_dir}";
        EnvironmentFile = "${backup_dir}/.env";
        ExecStart = "${backup_dir}/backup.sh";
        Environment = "PATH=${pkgs.restic}/bin:${pkgs.bash}/bin";
      };
    };

    systemd.user.timers.restic-sync = {
      Unit = { Description = "Restic periodic backup"; };
      Timer = {
        Unit = "restic-backup.service";
        OnCalendar = "daily";
      };
      Install = { WantedBy = [ "timers.target" ]; };
    };
  };
}
