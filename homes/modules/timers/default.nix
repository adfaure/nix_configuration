{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.adfaure.home-modules.user-timers;
in {
  options.adfaure.home-modules.user-timers = {
    enable = mkEnableOption "user-timers";
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
        ExecStart = "${lib.getExe pkgs.resticprofile} -c ${config.sops.secrets.restic-profile.path} backup";
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

    systemd.user.services.wasabi-restic-backup = {
      Unit = {
        Description = "Restic copy into wasabi bucket";
        After = ["sops-nix.service"];
      };
      Service = {
        CPUSchedulingPolicy = "idle";
        IOSchedulingClass = "idle";
        EnvironmentFile = "${config.sops.secrets.wasabi-token.path}";
        ExecStart = ''${lib.getExe pkgs.restic} \
                    --from-password-file ${config.sops.secrets.wasabi-repo-pass.path} \
                    copy --from-repo ${cfg.repository}'';
        Environment = [
          "PATH=${pkgs.restic}/bin:${pkgs.bash}/bin"
        ];
      };
    };
    systemd.user.timers.wasabi-restic-sync = {
      Unit = {
        Description = "Restic periodic backup";
      };
      Timer = {
        Unit = "wasabi-restic-backup.service";
        OnCalendar = "daily";
        Persistent = true;
      };
      Install = {WantedBy = ["timers.target"];};
    };
  };
}
