{ config, lib, pkgs, ... }:
let
  cfg = config.environment.adfaure.taskserver;
in
  with lib;
  {
    options.environment.adfaure.taskserver = {
      enable = mkEnableOption "taskserver";
    };

    config = mkIf config.environment.adfaure.taskserver.enable {
      environment.systemPackages = with pkgs; [ taskserver ];

      services.taskserver = {
        enable = true;
        fqdn = "adfaure";
        listenHost = "localhost";
        dataDir = "/var/lib/taskd";
        organisations.phd.users = [ "adfaure" ];
      };

    };
  }
