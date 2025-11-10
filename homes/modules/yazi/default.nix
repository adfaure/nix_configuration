{
  lib,
  ...
}: {
  programs.yazi =  {
    enable = true;
  };

  programs.zsh = {
    initExtra = lib.mkAfter ''
      # Add ctrl+N shortcut to navigate with yazi and zsh

      # FIXME: do it with home manager if its slows down zsh start too much
      mkdir -p $HOME/.config/yazi/

      function _yazi() {
        yazi --cwd-file $HOME/.config/yazi/cwd_file "$(pwd)" <$TTY

        print -n "\033[A"
        zle && zle -I
        cd "$(cat $HOME/.config/yazi/cwd_file)"
      }

      zle -N _yazi
      bindkey -v '^N' _yazi
    '';
  };
}
