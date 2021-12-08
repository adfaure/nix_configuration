{ config, lib, pkgs, my-dotfiles, wrapCmd, ... }:
{
  home.packages = [ ];
  home.file.".emacs".text = builtins.readFile "${my-dotfiles}/files/emacs_conf";
}
