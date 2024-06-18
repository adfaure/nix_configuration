{ lib, config, pkgs, home, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.adfaure.home-modules.eza-alias;
in {
  options.adfaure.home-modules.eza-alias = {
    enable = mkEnableOption "eza-alias";
  };

  # No icons for now
  config = mkIf cfg.enable {
    programs.eza = {
      enable = true;
      icons = true;
    };

    home.packages = [
      (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    ];
  };
}
