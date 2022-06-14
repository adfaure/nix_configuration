{ config, lib, pkgs, my-dotfiles, wrapCmd, ... }:
{
  home.packages = [
    pkgs.myEmacs
    (pkgs.aspellWithDicts (d: [d.fr d.en]))
  ];
  home.file.".aspell.conf".text = "data-dir ${pkgs.aspell}/lib/aspell";
  home.file.".emacs".text = builtins.readFile "${my-dotfiles}/files/emacs_conf";
}
