{
  lib,
  config,
  pkgs,
  sops,
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
    in
    {
      Unit = { 
        Description = "Restic backup"; 
        After = [ "sops-nix.service" ];
      };
      Service = {
        CPUSchedulingPolicy = "idle";
        IOSchedulingClass = "idle";
        EnvironmentFile = "${config.sops.secrets.restic-password.path}";
        ExecStart = "${lib.getExe pkgs.resticprofile} -c ${config.sops.secrets.restic-profile.path} backup";
        Environment = [
          "PATH=${pkgs.restic}/bin:${pkgs.bash}/bin"
          "RESTIC_REPOSITORY=${config.home.homeDirectory}/.restic-repository"
        ];
      };
    };

    systemd.user.timers.restic-sync = {
      Unit = { 
        Description = "Restic periodic backup"; 
        After = [ "sops-nix.service" ];
      };
      Timer = {
        Unit = "restic-backup.service";
        OnCalendar = "daily";
      };
      Install = { WantedBy = [ "timers.target" ]; };
    };
  };
}
