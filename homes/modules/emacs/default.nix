{ config, lib, pkgs, my-dotfiles, wrapCmd, ... }:
{
  home.file.".emacs".text = builtins.readFile "${my-dotfiles}/files/emacs_conf";
}
