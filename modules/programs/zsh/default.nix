{ config, lib, pkgs, my-dotfiles, ... }:

with lib;

let
vimrc = builtins.readFile "${my-dotfiles}/files/vimrc";
  cfg = config.environment.adfaure.programs.zsh;

  zshrc = builtins.readFile("${my-dotfiles}/files/zshrc");
  zshrc_local = pkgs.writeTextFile {
    name = "zshrc.local";
    text = builtins.readFile("${my-dotfiles}/files/zshrc.local");
  };

in
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    autosuggestions = {
      enable = true;
    };

    shellAliases = {
      r = "ranger";
      vim = "v";
      b = "bat";
      ns = "nix-shell";
      cat = "bat --paging=never --style=\"plain\"";
    };

    ohMyZsh = {
      enable = true;
      theme = "norm";
      plugins = [ "git" "command-not-found" "tig" "sudo" ];
    };

    interactiveShellInit = ''
      source ${zshrc_local}
    '';
  };

  environment.systemPackages = with pkgs; [
    nix-zsh-completions
    fasd
    zsh-completions
    zsh-navigation-tools
    tig
  ];
}

