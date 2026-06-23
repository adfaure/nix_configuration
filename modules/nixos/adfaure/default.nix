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
  username = "adfaure";

in {
  options.nixosModules.adfaure = {
    enable = mkEnableOption "adfaure";
  };

  config = mkIf cfg.enable {
    users.users.adfaure = {
      isNormalUser = true;
      home = "/home/${username}";
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
    home-manager.extraSpecialArgs = {system = "x86_64-linux"; inherit unstable username; };

    home-manager.users."${username}" = {...}: {
      imports = (lib.mkHomeModule inputs username).modules;
    };

  };
}
