{
  config,
  lib,
  pkgs,
  my-dotfiles,
  ...
}: let
  zshrc = builtins.readFile "${my-dotfiles}/files/tmux";
in {
  programs.tmux = {
    enable = true;
    extraConfig =
      builtins.readFile "${my-dotfiles}/files/tmux"
      + ''
        bind-key C-h display-popup -E -h 75% -w 75% -d "#{pane_current_path}" "htop"
        bind-key C-s display-popup -E -h 75% -w 75% -d "#{pane_current_path}" "(tmux new-session -s scratch -d && tmux new-window -t scratch:4 'emacs -nw ~/Projects/Notes/Journal.org'); tmux a -t scratch:1"

        # bind-key C-p display-popup -E -h 75% -w 75% -d "#{pane_current_path}" "tmux attach -t scratch:2"
        # bind-key C-r display-popup -E -h 75% -w 75% -d "#{pane_current_path}" "tmux attach -t scratch:3"
        bind-key C-j display-popup -E -h 75% -w 75% -d "#{pane_current_path}" "tmux attach -t scratch:4"
      '';
  };

  home.packages = with pkgs; [];
}
