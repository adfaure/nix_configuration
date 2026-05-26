{
  lib,
  pkgs,
  ...
}: let
  zshrc_local = pkgs.writeTextFile {
    name = "zshrc.local";
    text = ''
      export PAGER=bat

      # https://github.com/sharkdp/bat/issues/652
      export MANROFFOPT="-c"
      export MANPAGER="sh -c 'col -bx | bat -l man -p'"
      # This enables to use bat as pager without infinite recursion
      export BAT_PAGER="less -RF"
      ## Git alias

      export TIMEFMT='%J   %U  user %S system %P cpu %*E total'$'\n'\
      'avg shared (code):         %X KB'$'\n'\
      'avg unshared (data/stack): %D KB'$'\n'\
      'total (sum):               %K KB'$'\n'\
      'max memory:                %M MB'$'\n'\
      'page faults from disk:     %F'$'\n'\
      'other page faults:         %R'

      # Set vim bindings
      bindkey -v

      # Start ranger file navigator
      bindkey '^r' history-incremental-search-backward

      # ctrl+space for autosuggest-accept
      bindkey '^ ' autosuggest-accept

      # nix shell hook
      any-nix-shell zsh --info-right | source /dev/stdin
    '';
  };
in {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;

    shellAliases = {
      t1 = "tree -L 1";
      t2 = "tree -L 2";
      t3 = "tree -L 3";

      v = "vim";
      vim = "nvim";
      t = "task";
      b = "bat";
      cat = ''bat --paging=never --style="plain"'';
      ycat = ''bat --paging=never --style="plain" -l yaml'';
      jcat = ''bat --paging=never --style="plain" -l json'';
      ybat = ''bat --style="plain" -l yaml'';
      jbat = ''bat --style="plain" -l json'';
      # vim = ''nvim'';
      j = "jump";
      # So remote shells are not completly lost because they don't know kitty
      ssh = "TERM=xterm-color ssh";
      # nix
      ns = "nix shell";
      nd = "nix develop";
      nr = "nix run";
    };

    sessionVariables = {EDITOR = "nvim";};

    oh-my-zsh = {
      enable = true;
      plugins = ["git" "tig" "themes" "z" "jump" "colored-man-pages" "copybuffer"];
    };

    initContent = lib.mkAfter ''
      source ${zshrc_local}

      # Till they fix: https://github.com/nix-community/home-manager/issues/3100
      export EDITOR=nvim
      nstart() {
        NIXPKGS_ALLOW_UNFREE=1 nix run nixpkgs#$1 --impure
      }
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  home.packages = with pkgs; [
    # nix-zsh-completions
    fasd
    zsh-completions
    zsh-navigation-tools
    tig
    zsh
    any-nix-shell
    xclip
  ];
}
