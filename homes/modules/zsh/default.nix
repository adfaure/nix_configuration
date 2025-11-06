{
  config,
  lib,
  pkgs,
  my-dotfiles,
  ...
}: let
  zshrc_local = pkgs.writeTextFile {
    name = "zshrc.local";
    text = builtins.readFile "${my-dotfiles}/files/zshrc.local";
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

    initExtraFirst = lib.mkAfter ''
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
