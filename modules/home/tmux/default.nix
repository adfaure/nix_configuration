{
  config,
  lib,
  pkgs,
  my-dotfiles,
  ...
}: {
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    extraConfig = ''
       # Define the prefix
      set -g prefix C-a

      # Restore emacs behavior
      set -s escape-time 0

      # Split pane horizontally
      bind-key - split-window -v -c '#{pane_current_path}'
      # split pane vertically
      bind-key / split-window -h -c '#{pane_current_path}'

      # The windows start at 1 and not 0
      set -g base-index 1

      # Upda the numbering of the windows
      set -g renumber-windows on
      set -g mouse on

      # Prefix-r to reload the config
      bind-key r source-file ~/.tmux.conf

      # Create a new window from the current pane path
      unbind c
      bind-key c new-window -c '#{pane_current_path}'

      # Status line
      set -g status-right-length "100"

      # Use P to paste the content of the buffer
      bind P paste-buffer

      # Some vim-like behaviour
      ## Moving around
      set-window-option -g mode-keys vi
      # be sure to see note* below

      set-option -g status-interval 5
      set-option -g automatic-rename on
      set-option -g automatic-rename-format '#{b:pane_current_path}'

      # unbind h
      # bind h select-pane -L
      # unbind j
      # bind j select-pane -D
      # unbind k
      # bind k select-pane -U
      # unbind l
      # bind l select-pane -R

    '';
  };
}
