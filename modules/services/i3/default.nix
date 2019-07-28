{ config, lib, pkgs, ... }:
with lib;
let
  cfg=config.environment.adfaure.services.i3;
  i3conf = builtins.readFile(./i3conf);

  cfgBlocks = ''
  [time]
  label= 
  command=TZ='Europe/Paris' date '+%H:%M'
  interval=5

  [rofi-calendar]
  command=${./i3blocks/rofi-calendar/rofi-calendar}
  interval=3600
  LABEL= 
  DATEFTM=+%a. %d. %b. %Y
  SHORTFTM=+%d.%m.%Y

  [mediaplayer]
  command=${./i3blocks/mediaplayer/mediaplayer}
  instance=spotify
  interval=5
  signal=10

  [monitors]
  command=${./i3blocks/monitor_manager/monitor_manager}
  interval=once

  [volume]
  command=${./i3blocks/volume/volume}
  LABEL=♪
  interval=once
  signal=10

  [battery]
  command=${./i3blocks/battery2/battery2}
  interval=30
  markup=pango
  #LABEL=BAT
  LABEL=⚡
  #BAT_NUMBER=0
  '';

in
{
  options.environment.adfaure.services.i3 = {
    enable = mkEnableOption "i3";
    extraI3Conf = mkOption {
      type = types.string;
      default = "";
      example = "";
      description = ''
      extra i3 config
      '';
    };
  };

  config = mkIf cfg.enable {

    environment.etc.i3blocks = {
      # Creates /etc/nanorc
      target = "i3blocks.conf";
      text = cfgBlocks;
        # The UNIX file mode bits
      # mode = "0440";
    };

    fonts.enableFontDir = true;
    fonts.enableGhostscriptFonts = true;
    fonts.fonts = with pkgs; [
      font-awesome_5
      font-awesome-ttf
    ];

    environment.systemPackages = with pkgs; [
      font-awesome-ttf
      i3blocks
      (python3.withPackages (ps: with ps; with python3Packages; [
        # Add python packages here
        python3
        tkinter
      ]))
      rxvt_unicode
      feh
      # Batery info
      acpi
      # controle media player
      playerctl
      rofi
    ];
    services.xserver = {
      windowManager.i3.enable = true;
      windowManager.i3.package = pkgs.i3-gaps;
      windowManager.i3.configFile =
        pkgs.writeText "i3.conf" ( cfg.extraI3Conf + i3conf);
    };
  };
}
