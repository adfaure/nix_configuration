{ config, lib, pkgs, my-dotfiles, ... }:

with lib;
let cfg = config.environment.adfaure.programs.vim;
in {
  environment.sessionVariables.EDITOR = "v";
  environment.sessionVariables.VISUAL = "v";

  environment.systemPackages = [
    (pkgs.callPackage ./my_vim.nix { inherit my-dotfiles; })
    pkgs.ctags
    pkgs.ack
    #      pkgs.cargo
    #      pkgs.rustfmt
    #      pkgs.rustc
    #      pkgs.rls
  ];
}
