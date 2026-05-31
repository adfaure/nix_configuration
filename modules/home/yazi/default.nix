{lib, ...}: {config, ...}: let
  cfg = config.homeManagerModules.yazi;
in {
  options.homeManagerModules.yazi = {
    enable = lib.mkEnableOption "yazi";
  };

  config = lib.mkIf cfg.enable {
    programs.yazi = {
      enable = true;
    };

    programs.zsh = {
      initContent = lib.mkAfter ''
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
  };
}
