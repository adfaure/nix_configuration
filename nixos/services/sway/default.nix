{
  config,
  lib,
  pkgs,
  my-dotfiles,
  ...
}:
with lib; let
  cfg = config.environment.adfaure.services.sway;
  # i3conf = builtins.readFile "${my-dotfiles}/files/i3";
in {
  options.environment.adfaure.services.sway = {
    enable = mkEnableOption "sway";
    extraI3Conf = mkOption {
      type = types.lines;
      default = "";
      example = "";
      description = ''
        extra i3 config
      '';
    };
  };

  config = mkIf cfg.enable {
    fonts.enableGhostscriptFonts = true;
    fonts.fonts = with pkgs; [font-awesome_5 font-awesome];

    environment.systemPackages = with pkgs; [
      blueman
      i3blocks
      rxvt_unicode
      # Batery info
      acpi
      # controle media player
      playerctl
      wirelesstools
      networkmanager_dmenu
      sysstat

      rofi
      # Mediaplayer
      # perl
    ];

    programs.sway.enable = true;

  };
}
