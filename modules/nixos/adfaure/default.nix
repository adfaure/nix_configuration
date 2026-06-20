{
  lib,
  inputs,
  ...
}: {
  pkgs,
  unstable,
  config,
  ...
}:
with lib; let
  cfg = config.nixosModules.adfaure;
in {
  options.nixosModules.adfaure = {
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

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    # Lucky me only one kind of system for now
    home-manager.extraSpecialArgs = {system = "x86_64-linux"; inherit unstable; };

    home-manager.users.adfaure = {...}: {
      imports = (lib.mkHomeModule inputs "adfaure").modules;
    };
  };
}
