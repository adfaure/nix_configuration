{ config, pkgs, my-dotfiles, emacs-overlay, ... }: {

  imports = [ ./modules/emacs ./modules/vim ./modules/zsh ./modules/ranger ];

  # Top level configuration for the user adfaure (me!)
  config = {
    # First we activate home-manager
    programs.home-manager.enable = true;
    # Small git config (should I make a dedicated module?)
    programs.git = {
      enable = true;
      userName = "adfaure";
      userEmail = "adrien.faure@protonmail.com";
    };

    home.stateVersion = "20.09";
    home.username = "adfaure";
    home.homeDirectory = "/home/adfaure";

    home.file.".tmux".text = builtins.readFile "${my-dotfiles}/files/tmux";
    home.file.".config/sakura/sakura.conf".text =
      builtins.readFile "${my-dotfiles}/files/sakura.conf";

    home.packages = with pkgs; [
      evince
      sakura
      any-nix-shell
      taskwarrior
      pass
      taskwarrior
      timewarrior
      nitrokey-app
      cloc
      jq
      pdftk
      bat
      tree
      manpages
      gcc
      wget
      cmake
      gdb
      direnv
      entr
      pandoc
    ];
  };
}