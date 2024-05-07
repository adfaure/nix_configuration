({
  lib,
  config,
  my-dotfiles,
  cgvg,
  guix,
  ...
}:
with lib;
let
  cfg = config.adfaure.modules.guix;
in {
  options.adfaure.modules.guix = {
    enable = mkEnableOption "guix service";
  };

  config = mkIf cfg.enable {
    # Small module to enable guix on nixos
    services.guix.enable = true;
    environment.systemPackages = [
      guix
    ];
  };
})
