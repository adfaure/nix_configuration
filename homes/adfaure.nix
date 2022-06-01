{ nixpkgs, options, modulesPath, lib, config, pkgs, my-dotfiles, emacs-overlay
, cgvg, ... }: {

  imports = [
    ./base.nix
    # ./modules/spotifyd
  ];

  # Top level configuration for the user adfaure (me!)
  config = {
    nixpkgs.config.allowUnfree = true;
    # https://github.com/nix-community/home-manager/issues/2942#issuecomment-1119760100
    nixpkgs.config.allowUnfreePredicate = (pkg: true);
    # First we activate home-manager
    programs.home-manager.enable = true;
    home.file.".config/sakura/sakura.conf".text =
      builtins.readFile "${my-dotfiles}/files/sakura.conf";

    programs.browserpass = {
      enable = true;
      browsers = [ "firefox" ];
    };

    home.packages = with pkgs; [
      # Texteditors / IDE
      myVscode

      # Terminal
      sakura
      kitty

      # PDF reader
      pdftk
      evince

      # Web
      firefox

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
      man-pages
      gcc
      wget
      gdb
      direnv
      entr
      pandoc

      # Nix file formating
      nixfmt

      # GUI applications
      # calibre
      spotify

      # spotify-tui
    ];
  };
}
