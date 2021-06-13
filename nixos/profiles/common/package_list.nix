{ config, lib, pkgs, ... }:
with lib; {
  options.environment.adfaure.environments.headless = {
    enable = mkEnableOption "headless";
  };
  # We make it as an option
  config = mkIf config.environment.adfaure.environments.headless.enable {
    environment.systemPackages = with pkgs; [
      # Administration

      # monitoring
      psmisc
      pmutils
      nmap
      htop
      # tools
      tmux
      libcaca # video
      highlight # code
      atool # archives
      w3m # web
      poppler # PDF
      mediainfo # audio and video
      qemu
    ];
  };
}
