{ nixpkgs, options, modulesPath, lib, config, pkgs, my-dotfiles, emacs-overlay
, cgvg, ... }: {

  imports = [
    ./base.nix
    ./modules/spotifyd
  ];

  # Top level configuration for the user adfaure (me!)
  config = {
    # First we activate home-manager
    programs.home-manager.enable = true;
    home.file.".config/sakura/sakura.conf".text =
      builtins.readFile "${my-dotfiles}/files/sakura.conf";

    home.packages = with pkgs; [
      # Texteditors / IDE
      myVscode
      myEmacs

      # Terminal
      sakura
      kitty

      # PDF reader
      pdftk
      evince

      # Web
      # firefox

      # Lang
      go

      bat # cat with colors for code
      cloc
      pass
      taskwarrior
      timewarrior
      nitrokey-app
      jq
      cgvg
      tree
      manpages
      gcc
      wget
      gdb
      direnv
      entr
      pandoc

      # Nix file formating
      nixfmt

      # GUI applications
      calibre
      spotify

      spotify-tui
    ];
  };
}
