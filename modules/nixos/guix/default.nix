{ inputs, lib, ... }: {
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.adfaure.nixosModules.guix;
in {
  options.adfaure.nixosModules.guix = {
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
