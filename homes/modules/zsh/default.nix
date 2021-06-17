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
      v = "nvim";
      t = "task";
      b = "bat";
      ns = "nix-shell";
      cat = ''bat --paging=never --style="plain"'';
      ranger = "ranger --confdir=$HOME/.config/ranger";
      vim = ''nvim'';
      j = "jump";
    };

    oh-my-zsh = {
      custom = "${my-dotfiles}/files/custom_zsh";
      enable = true;
      theme = "adfaure";
      plugins = [ "git" "tig" "sudo" "themes" "z" "jump" "colored-man-pages" "copybuffer" ];
    };

    initExtra = lib.mkAfter ''
      source ${zshrc_local}
      if [[ "$TERM_PROGRAM" == "vscode" ]]; then
        echo "running term in vscode, moving shell to another cgroup"
        export TERM_PROGRAM=vscode-cgroup-out
        systemd-run --scope --slice=exp-shell.slice -p 'Delegate=yes' zsh
        exit 0
      fi
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
