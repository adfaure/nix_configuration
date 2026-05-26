{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.adfaure.services.nix-sops;
in {
  options.adfaure.services.nix-sops = {
    enable = mkEnableOption "nix-sops";
  };

  config = lib.mkIf cfg.enable {
    sops = {
      age.keyFile = "/home/adfaure/.config/sops/age/keys.txt";
      defaultSopsFile = ../../../secrets/private.yaml;
      defaultSymlinkPath = "/run/user/1000/secrets";
      defaultSecretsMountPoint = "/run/user/1000/secrets.d";
      secrets.restic-password = {};
      secrets.wasabi-repo-pass = {};
      secrets.wasabi-token = {};
      secrets.restic-profile = {
        path = "${config.xdg.configHome}/resticprofile/conf.yaml";
      };
    };
  };
}
