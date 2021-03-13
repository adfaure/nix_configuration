{ nixpkgs, options, modulesPath, lib, config, pkgs, my-dotfiles, emacs-overlay
, cgvg, ... }: {

  imports = [ ./modules/emacs ./modules/vim ./modules/zsh ./modules/ranger ];

  # Top level configuration for the user adfaure (me!)
  config = {
    # First we activate home-manager
    programs.home-manager.enable = true;
    # Small git config (should I make a dedicated module?)
    programs.git = {
      enable = true;
      userName = "Adrien Faure";
      userEmail = "adrien.faure@protonmail.com";
      aliases = {
        ds = "diff --staged";
        l =
          "log --pretty=format:'%C(auto,yellow)%h%C(auto,magenta) %C(auto,blue)%ad %C(auto,green)%aN %C(auto,reset)%s%C(auto)% gD%d' --graph --date=format:'%Y-%m-%d %H:%M:%S' --decorate-refs-exclude='refs/remotes/*/HEAD'";
        st = "status";
        chk = "checkout";
      };
    };

    home.stateVersion = "20.09";
    home.username = "adfaure";
    home.homeDirectory = "/home/adfaure";

    home.file.".tmux".text = builtins.readFile "${my-dotfiles}/files/tmux";
    home.file.".config/sakura/sakura.conf".text =
      builtins.readFile "${my-dotfiles}/files/sakura.conf";

    home.packages = with pkgs; [
      # nur.repos.kapack.cgvg
      cgvg
      evince
      sakura
      any-nix-shell
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
      nixfmt
    ];
  };
}
