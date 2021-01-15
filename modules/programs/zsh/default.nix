{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.environment.adfaure.programs.zsh;
  zshrc = builtins.readFile(./zshrc);

  zshrc_local = pkgs.writeTextFile {
    name = "zshrc.local";
    text = builtins.readFile(./zshrc.local);
  };

in
{

  options.environment.adfaure.programs.zsh = {
    enable = mkEnableOption "zsh";
  };

  config = mkIf config.environment.adfaure.programs.zsh.enable {

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

    environment.systemPackages = [
      pkgs.nix-zsh-completions
      pkgs.fasd
      pkgs.zsh-completions
      pkgs.zsh-navigation-tools
      pkgs.tig
      #adfaurePkgs.direnv
    ];

  };
}

