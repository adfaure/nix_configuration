{inputs, ...}: {
  flake.modules.homeManager.graphical = {pkgs, ...}: let
    inherit (inputs) my-dotfiles;
  in {
    config = {
      nixpkgs.config.allowUnfree = true;
      # https://github.com/nix-community/home-manager/issues/2942#issuecomment-1119760100
      nixpkgs.config.allowUnfreePredicate = pkg: true;
      # First we activate home-manager
      programs.home-manager.enable = true;

      home.file.".config/sakura/sakura.conf".text =
        builtins.readFile "${my-dotfiles}/files/sakura.conf";

      programs.browserpass = {
        enable = true;
        browsers = ["firefox"];
      };

      programs.direnv = {
        enable = true;
        enableBashIntegration = true; # see note on other shells below
        nix-direnv.enable = true;
      };

      # programs.vscode = {
      #   enable = true;
      #   package = pkgs.vscode.fhsWithPackages (ps: with ps; [rustup zlib openssl.dev pkg-config]);
      # };

      home.packages = with pkgs; [
        # Texteditors / IDE
        # myVscode

        # Terminal
        sakura
        kitty
        ghostty

        # PDF reader
        pdftk
        evince

        # Web
        firefox

        # Tools
        bat # cat with colors for code
        cloc
        pass
        nitrokey-app

        # GUI applications
        calibre

        signal-desktop
        flameshot # Screenshot

        # Photo
        darktable

        # Messaging
        discord
        telegram-desktop
        element-desktop

        lazygit
        meld
        obsidian
        jetbrains.pycharm-community

        # TODO
        # pkgs.cgvg-rs
      ];
    };
  };
}
