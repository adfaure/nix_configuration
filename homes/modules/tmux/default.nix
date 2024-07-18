{
  config,
  lib,
  pkgs,
  my-dotfiles,
  ...
}: let
  zshrc = builtins.readFile "${my-dotfiles}/files/tmux";
in {
  # home.file.".tmux".text = builtins.readFile "${my-dotfiles}/files/tmux";

  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    extraConfig =
      builtins.readFile "${my-dotfiles}/files/tmux";
  };
}
