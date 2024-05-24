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
      builtins.readFile "${my-dotfiles}/files/tmux"
      + ''
        bind-key C-h display-popup -E -h 75% -w 75% -d "#{pane_current_path}" "${pkgs.zenith}/bin/zenith"
        bind-key C-s display-popup -E -h 75% -w 75% -d "#{pane_current_path}" "(tmux new-session -s scratch -d && tmux new-window -t scratch:4 'nvim "+:ObsidianToday"'); tmux a -t scratch:1"

        bind-key C-j display-popup -E -h 75% -w 75% -d "#{pane_current_path}" "tmux attach -t scratch:4"
      '';
  };
}
