{lib, ...}: {
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixosModules.user;
in {
  options.nixosModules.user = {
    enable = mkEnableOption "user";
  };

  config = mkIf cfg.enable {
    users.users.adfaure = {
      isNormalUser = true;
      home = "/home/adfaure";
      shell = pkgs.zsh;

      extraGroups = [
        "audio"
        "wheel"
        "networkmanager"
        "vboxusers"
        "lp"
        "perf_users"
        "docker"
        "users"
      ];

      initialPassword = "nixos";
      uid = 1000;
    };
  };
}
