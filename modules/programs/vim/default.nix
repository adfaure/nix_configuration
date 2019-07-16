{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.environment.adfaure.programs.vim;
in
{
  options.environment.adfaure.programs.vim = {
    enable = mkEnableOption "vim ";
  };

  config = mkIf config.environment.adfaure.programs.vim.enable rec {

    environment.sessionVariables.EDITOR="v";
    environment.sessionVariables.VISUAL="v";

    environment.systemPackages = [
      (pkgs.callPackage ./my_vim.nix { })
      pkgs.ctags
      pkgs.ack
#      pkgs.cargo
#      pkgs.rustfmt
#      pkgs.rustc
#      pkgs.rls
    ];
  };
}
