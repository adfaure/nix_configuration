{ config, lib, pkgs, ... }:
let

  cfg = config.environment.adfaure.development;

in
  with lib;
  {
    options.environment.adfaure.gitlabrunners = {
      enable = mkEnableOption "gitlabrunners";
      keys = mkOption {
        type = types.listOf types.string;
        default = [];
        example = [];
        description = ''
          The list of Ssh keys allowed to log.
        '';
      };
    };

    config = mkIf config.environment.adfaure.gitlabrunners.enable {

      services = {
        gitlab-runner = {
          enable = true;
          configOptions = {
            name = "shell";
            url = "https://gricad-gitlab.univ-grenoble-alpes.fr/";
            token = "K-B6Mb1dYLRzYG8qXFMk";
            executor = "shell";
            builds_dir = "/tmp";
          };
        };
      };
    };
  }
