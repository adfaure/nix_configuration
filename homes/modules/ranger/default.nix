{ config, lib, pkgs, my-dotfiles, ... }: {
  # Home module for ranger configuration.
  # It also depends on zsh.
  home.packages = [ pkgs.ranger pkgs.atool pkgs.poppler_utils ];

  programs.zsh = {
    initExtra = lib.mkAfter ''
      # Add ctrl+N shortcut to navigate with ranger and zsh
      _ranger () {
        PYTHONPATH= command ${pkgs.ranger}/bin/ranger --confdir=$HOME/.config/ranger "$(pwd)"<$TTY
        print -n "\033[A"
        zle && zle -I
        cd "$(grep \^\' $HOME/.config/ranger/bookmarks | cut -b3-)"
      }

      zle -N _ranger
      bindkey -v '^N' _ranger
    '';
  };

  # Creating the file bookmarks wich is mutable.
  home.activation.linkMyStuff = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    touch ${config.home.homeDirectory}/.config/ranger/bookmarks
  '';

  # Importing the ranger conifguration files into my home
  home.file = {
    ".config/ranger/commands.py".text =
      builtins.readFile "${my-dotfiles}/files/ranger/commands.py";
    ".config/ranger/rc.conf".text =
      builtins.readFile "${my-dotfiles}/files/ranger/rc.conf";
    ".config/ranger/rifle.conf".text =
      builtins.readFile "${my-dotfiles}/files/ranger/rifle.conf";
    ".config/ranger/scope.sh".text =
      builtins.readFile "${my-dotfiles}/files/ranger/scope.sh";
  };
}
