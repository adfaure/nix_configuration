{ config, lib, pkgs, my-dotfiles, ... }: {
  # home.sessionVariables.EDITOR = "v";
  # home.sessionVariables.VISUAL = "v";
  home.packages = [
    (pkgs.callPackage ./my_vim.nix { inherit my-dotfiles; })
    pkgs.ctags
    pkgs.ack
    #      pkgs.cargo
    #      pkgs.rustfmt
    #      pkgs.rustc
    #      pkgs.rls
  ];
}
