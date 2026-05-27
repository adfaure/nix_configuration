{ lib, ... }: {
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.nixosModules.guix;
in {
  options.nixosModules.guix = {
    enable = mkEnableOption "guix";
  };

  config = mkIf cfg.enable {
    # Small module to enable guix on nixos
    services.guix.enable = true;
    environment.systemPackages = [
      pkgs.guix
    ];
  };
}
