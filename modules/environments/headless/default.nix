{ config, lib, pkgs, ... }:
with lib;
let
  kapack =  import (fetchTarball {
    name = "kapack";
    url = "https://github.com/oar-team/kapack/archive/84f1cb9a595d14a2c6f1cf44119d83ba2965ca4c.tar.gz";
    sha256 = "1hzlnc5gv6y8m04cxpjz9c34jb9qrwizadvpi41drlswzsm6s8md";
  }) { };
in
{
  options.environment.adfaure.environments.headless = {
    enable = mkEnableOption "headless";
  };

  config = mkIf config.environment.adfaure.environments.headless.enable {

    environment.systemPackages = with pkgs;[
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
      # ranger previews
      libcaca   # video
      highlight # code
      atool     # archives
      w3m       # web
      poppler   # PDF
      mediainfo # audio and video
      # my vim config
#      (pkgs.callPackage ./my_vim.nix { })
#      (pkgs.callPackage ./my_emacs.nix { })
      # nixops
      qemu
      # python3
      taskwarrior
      timewarrior
      nitrokey-app
      # pdftool
      pdftk
      kapack.cgvg
      # cat with Wings
      bat
      tree
    ];
  };
}
