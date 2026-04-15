{
  flake.modules.homeManager.nix-sops = {
    lib,
    config,
    ...
  }: let
    inherit (lib) mkEnableOption;
    cfg = config.adfaure.services.nix-sops;
  in {
    options.adfaure.services.nix-sops = {
      enable = mkEnableOption "nix-sops";
    };

    config = lib.mkIf cfg.enable {
      sops = {
        age.keyFile = "/home/${config.home.username}/.config/sops/age/keys.txt";
        defaultSopsFile = ../../../secrets/private.yaml;
        # defaultSymlinkPath = "/run/user/${config.home.username}/secrets";
        # defaultSecretsMountPoint = "/run/user/${config.home.username}/secrets.d";
        secrets.restic-password = {};
        secrets.wasabi-repo-pass = {};
        secrets.wasabi-token = {};
        secrets.restic-profile = {
          path = "${config.xdg.configHome}/resticprofile/conf.yaml";
        };
      };
    };
  };
}
