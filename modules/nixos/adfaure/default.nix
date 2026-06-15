{
  lib,
  inputs,
  ...
}: {config, ...}:
with lib; let
  cfg = config.nixosModules.adfaure;
in {
  options.nixosModules.adfaure = {
    enable = mkEnableOption "user";
  };

  config = mkIf cfg.enable {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    # Lucky me only one kind of system for now
    home-manager.extraSpecialArgs = {system = "x86_64-linux";};
    users.users.adfaure.isNormalUser = true;

    home-manager.users.adfaure = {...}: {
      imports = (lib.mkHomeModule inputs "adfaure").modules;
    };
  };
}
