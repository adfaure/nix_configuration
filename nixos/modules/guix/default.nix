{
  lib,
  config,
  my-dotfiles,
  cgvg,
  pkgs,
  ...
}:
with lib; let
  cfg = config.adfaure.modules.my-guix;
in {
  options.adfaure.modules.my-guix = {
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
