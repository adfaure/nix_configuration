{ config, lib, pkgs, my-dotfiles, ... }:
let
  zshrc = builtins.readFile ("${my-dotfiles}/files/zshrc");
  zshrc_local = pkgs.writeTextFile {
    name = "zshrc.local";
    text = builtins.readFile ("${my-dotfiles}/files/zshrc.local");
  };
  zshrc_theme = builtins.readFile ("${my-dotfiles}/files/dadou.zsh-theme");
in {


  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;

    shellAliases = {
      r = "ranger";
      v = "vim";
      vim = "nvim";
      t = "task";
      b = "bat";
      ns = "nix-shell";
      cat = ''bat --paging=never --style="plain"'';
      ranger = "ranger --confdir=$HOME/.config/ranger";
      # vim = ''nvim'';
      j = "jump";
      # So remote shells are not completly lost because they don't know kitty
      ssh = "TERM=xterm-color ssh";
    };

    sessionVariables = { EDITOR = "nvim"; };

    oh-my-zsh = {
      custom = "${my-dotfiles}/files/custom_zsh";
      enable = true;
      theme = "adfaure";
      plugins = [ "git" "tig" "themes" "z" "jump" "colored-man-pages" "copybuffer" ];
    };

    initExtraFirst = lib.mkAfter ''
      source ${zshrc_local}
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
  ];
}
