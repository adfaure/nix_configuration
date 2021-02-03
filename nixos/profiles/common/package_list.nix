{ config, lib, pkgs, ... }:
with lib; {
  options.environment.adfaure.environments.headless = {
    enable = mkEnableOption "headless";
  };
  # We make it as an option
  config = mkIf config.environment.adfaure.environments.headless.enable {
    environment.systemPackages = with pkgs; [
      manpages
      taskwarrior
      taskserver
      gitAndTools.gitFull
      gcc
      ctags
      gnumake
      wget
      cmake
      gdb
      direnv
      entr
      pandoc
      # Editors
      # Misc
      cloc
      jq
      qemu
      # printers
      saneBackends
      samsungUnifiedLinuxDriver
      # fun
      fortune
      sl
      sshfs
      # nix_utils
      nix-prefetch-scripts
      nix-zsh-completions
      # monitoring
      psmisc
      pmutils
      nmap
      htop
      # tools
      pass
      zsh
      any-nix-shell
      tmux

      libcaca # video
      highlight # code
      atool # archives
      w3m # web
      poppler # PDF
      mediainfo # audio and video
      qemu
      taskwarrior
      timewarrior
      nitrokey-app
      # pdftool
      pdftk
      # kapack.cgvg
      # cat with Wings
      bat
      tree
    ];
  };
}
