{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.adfaure.home-modules.vim-tmux-nav-conf;
in {
  options.adfaure.home-modules.vim-tmux-nav-conf = {
    enable = mkEnableOption "vim-tmux-nav-conf";
  };
  config = mkIf cfg.enable {
    programs.tmux.extraConfig = ''
      # Smart pane switching with awareness of Vim splits.
      # See: https://github.com/christoomey/vim-tmux-navigator
      # is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
      #     | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"

      # https://github.com/christoomey/vim-tmux-navigator/issues/295#issuecomment-1369954705
      # Enable tmux pan in subshell (such as poetry shell)
      is_vim="children=(); i=0; pids=( $(ps -o pid= -t '#{pane_tty}') ); \
        while read -r c p; do [[ -n c && c -ne p && p -ne 0 ]] && children[p]+=\" $\{c\}\"; done <<< \"$(ps -Ao pid=,ppid=)\"; \
        while (( $\{#pids[@]\} > i )); do pid=$\{pids[i++]\}; pids+=( $\{children[pid]-\} ); done; \
        ps -o state=,comm= -p \"$\{pids[@]\}\" | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"


      bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
      bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
      bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
      bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
      tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
      if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
      if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R
      bind-key -T copy-mode-vi 'C-\' select-pane -l
    '';

    programs.neovim = {
      extraConfig = ''
        let g:tmux_navigator_no_mappings = 1

        nnoremap <silent> <C-H> :<C-U>TmuxNavigateLeft<cr>
        nnoremap <silent> <C-J> :<C-U>TmuxNavigateDown<cr>
        nnoremap <silent> <C-K> :<C-U>TmuxNavigateUp<cr>
        nnoremap <silent> <C-L> :<C-U>TmuxNavigateRight<cr>
      '';

      plugins = [pkgs.vimPlugins.vim-tmux-navigator];
    };
  };
}
