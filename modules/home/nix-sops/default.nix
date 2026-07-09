{lib, ...}: {
  config,
  username,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.homeManagerModules.nix-sops;
in {
  options.homeManagerModules.nix-sops = {
    enable = mkEnableOption "nix-sops";
  };

  config = mkIf cfg.enable {
    sops = {
      age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
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
