{ config, lib, pkgs, ... }: {
  home.packages = [ pkgs.ranger pkgs.atool pkgs.poppler_utils ];

  # environment.shellAliases = { ranger = "ranger --confdir=$HOME/.ranger"; };

  # programs.zsh.interactiveShellInit = lib.mkAfter ''
  #   # Add ctrl+N shortcut to navigate with ranger and zsh
  #   _ranger () {
  #     PYTHONPATH= command ${pkgs.ranger}/bin/ranger --confdir=$HOME/.ranger "$(pwd)"<$TTY
  #     print -n "\033[A"
  #     zle && zle -I
  #     cd "$(grep \^\' $HOME/.ranger/bookmarks | cut -b3-)"
  #   }

  #   zle -N _ranger
  #   bindkey -v '^N' _ranger
  # '';
}