{ config, lib, pkgs, ... }:
let
  pkgs_lists = import ../config/my_pkgs_list.nix { inherit pkgs; };
  cfg = config.environment.adfaure.thync;
in
  with lib;
  {
    options.environment.adfaure.thync = {
      enable = mkEnableOption "thync";
      dataDir = mkOption {
        type = types.string;
        default = "/home/adfaure/.config/syncthing";
        description = ''
          Folder to sync
        '';
      };
    };

    config = mkIf config.environment.adfaure.thync.enable {
      environment.systemPackages = with  pkgs;  [ taskserver ];

      services.syncthing = {
        enable = true;
        user = "adfaure";
        group = "users";
        dataDir = "${cfg.dataDir}";
        # systemService = false;
      };

    };
  }
