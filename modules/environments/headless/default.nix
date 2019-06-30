
{ config, lib, pkgs, ... }:

with lib;
let
  frePkgs = import ../../../pkgs { };
in
{
  options.environment.adfaure.environments.headless = {
    enable = mkEnableOption "headless";
  };

  config = mkIf config.environment.adfaure.environments.headless.enable {

    environment.systemPackages = with pkgs;[
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
      hugo
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
      usbutils
      iotop
      stress
      tcpdump
      # files
      file
      tree
      ncdu
      unzip
      unrar
      # tools
      pass
      zsh
      any-nix-shell
      tmux
      ranger
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
      python3
      taskwarrior
      timewarrior
    ];
  };
}
