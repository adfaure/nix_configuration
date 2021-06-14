{ nixpkgs, options, modulesPath, lib, config, pkgs, my-dotfiles, emacs-overlay
, cgvg, ... }: {

  imports = [
    ./base.nix

    # GUI (disabled for experiment)
    # ./modules/emacs
    # ./modules/vscode

    ./modules/editor-exp
  ];

  # Top level configuration for the user adfaure (me!)
  config = {
    # First we activate home-manager
    programs.home-manager.enable = true;

    home.file.".config/sakura/sakura.conf".text =
      builtins.readFile "${my-dotfiles}/files/sakura.conf";

    home.packages = with pkgs; [
      # Terminal
      sakura

      # PDF reader
      pdftk
      evince

      # Lang
      go
      # Linux and dev tools
      any-nix-shell
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
    ];
  };
}
