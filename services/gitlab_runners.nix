{ config, lib, pkgs, ... }:
let

  cfg = config.services.gitlabrunners;
  secrets = import ../secrets.nix;
  configFile = /home/adfaure/.gitlab-runner/config.toml;

in
  with lib;
  {
    options.services.gitlabrunners = {

      enable = mkEnableOption "gitlabrunners";

      workDir = mkOption {
        default = "/var/lib/gitlab-runner";
        type = types.path;
        description = "The working directory used";
      };

    };

    config = mkIf cfg.enable {

      systemd.services.gitlab-runner = {
        description = "Gitlab Runner";
        after = [ "network.target" "docker.service" ];
        requires = [ "docker.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = ''${pkgs.gitlab-runner.bin}/bin/gitlab-runner run \
            --working-directory /tmp/ \
            --config ${configFile} \
            --service gitlab-runner \
            --user gitlab-runner \
          '';
        };
      };

      users.extraUsers.gitlab-runner = {
        group = "gitlab-runner";
        extraGroups = [ "docker" ];
        uid = config.ids.uids.gitlab-runner;
        home = cfg.workDir;
        createHome = true;
      };

      users.extraGroups.gitlab-runner.gid = config.ids.gids.gitlab-runner;
    };

  }
