{ config, lib, pkgs, my-dotfiles, ... }: {
  home.packages = [
    (pkgs.callPackage ./my_vim.nix { inherit my-dotfiles; })
    pkgs.ctags
    pkgs.ack
  ];
}
