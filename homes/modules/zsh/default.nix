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
      vim = "nvim";
      v = "nvim";
      t = "task";
      b = "bat";
      ns = "nix-shell";
      cat = ''bat --paging=never --style="plain"'';
      ranger = "ranger --confdir=$HOME/.config/ranger";
    };

    oh-my-zsh = {
      enable = true;
      # theme = "juanghurtado";
      # theme = "dadou";
      plugins = [ "git" "tig" "sudo" "themes" "z" ];
    };

    initExtra = lib.mkAfter ''
      source ${zshrc_local}
      # Source custom theme
      ${zshrc_theme}
      '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  home.packages = with pkgs; [
    nix-zsh-completions
    fasd
    zsh-completions
    zsh-navigation-tools
    tig
    zsh
  ];
}
