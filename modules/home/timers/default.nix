{
  lib,
  inputs,
  ...
}: {
  config,
  system,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.homeManagerModules.timers;
in {
  options.homeManagerModules.timers = {
    enable = mkEnableOption "timers";
    repository = mkOption {
      default = "${config.home.homeDirectory}/.restic-repository";
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.restic-backup = {
      Unit = {
        Description = "Restic backup";
        After = ["sops-nix.service"];
      };
      Service = {
        CPUSchedulingPolicy = "idle";
        IOSchedulingClass = "idle";
        EnvironmentFile = "${config.sops.secrets.restic-password.path}";
        ExecStart = "${lib.getExe inputs.self.packages."${system}".resticprofile} -c ${config.sops.secrets.restic-profile.path} backup";
        Environment = [
          "PATH=${pkgs.restic}/bin:${pkgs.bash}/bin"
          "RESTIC_REPOSITORY=${cfg.repository}"
        ];
      };
    };
    systemd.user.timers.restic-sync = {
      Unit = {
        Description = "Restic periodic backup";
      };
      Timer = {
        Unit = "restic-backup.service";
        OnCalendar = "*-*-* 22:00:00";
        Persistent = true;
      };
      Install = {WantedBy = ["timers.target"];};
    };
  };
}
