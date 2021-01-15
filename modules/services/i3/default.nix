{ config, lib, pkgs, ... }:
with lib;
let
  cfg=config.environment.adfaure.services.i3;
  i3conf = builtins.readFile(./i3conf);

  cfgBlocks = ''
  [mediaplayer]
  command=${./i3blocks/mediaplayer/mediaplayer}
  instance=spotify
  interval=5
  signal=10

  [volume]
  command=${./i3blocks/volume/volume}
  label=♪
  interval=once
  signal=10

  [time]
  label=⏰
  command=TZ='Europe/Paris' date '+%H:%M'
  interval=5

  [rofi-calendar]
  command=${./i3blocks/rofi-calendar/rofi-calendar}
  interval=3600
  label= 
  dateftm=+%a. %d. %b. %Y
  shortftm=+%d.%m.%Y

  [cpu_usage]
  command=${./i3blocks/cpu_usage/cpu_usage}
  interval=10
  LABEL=☕
  min_width=☕100.00%
  # T_WARN=50
  # T_CRIT=80
  # DECIMALS=2

  [memory]
  command=${./i3blocks/memory/memory}
  label=MEM
  interval=30

  [essid]
  command=${./i3blocks/essid/essid}
  interval=60
  interface=wlp2s0

  [iface]
  command=${./i3blocks/iface/iface}
  #network=
  #IFACE=wlan0
  #ADDRESS_FAMILY=inet6?
  color=#00FF00
  interval=10

  [battery]
  command=${./i3blocks/battery2/battery2}
  interval=30
  markup=pango
  #LABEL=BAT
  label=⚡
  #BAT_NUMBER=0

  # [monitors]
  # command=${./i3blocks/monitor_manager/monitor_manager}
  # interval=once
  '';

in
{
  options.environment.adfaure.services.i3 = {
    enable = mkEnableOption "i3";
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
      wirelesstools
      networkmanager_dmenu
      # Mediaplayer
      perl
    ];

    services.xserver = {
      # videoDrivers = [ "nvidia" ];

      windowManager.i3.enable = true;
      windowManager.i3.package = pkgs.i3-gaps;
      windowManager.i3.configFile =
        pkgs.writeText "i3.conf" ( cfg.extraI3Conf + i3conf);
    };
  };
}
