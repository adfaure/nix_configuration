{
  unstable,
  pkgs,
  my-dotfiles,
  ...
}: {
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

    programs.vscode = {
      enable = true;
      package = pkgs.vscode.fhsWithPackages (ps: with ps; [rustup zlib openssl.dev pkg-config]);
    };

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
      jq
      tree
      man-pages
      gcc
      wget
      gdb
      direnv
      entr
      pandoc
      nvtopPackages.full

      # Nix file formating
      # nixfmt-classic

      # GUI applications
      calibre

      signal-desktop
      rofi
      flameshot # Screenshot

      # Photo
      unstable.darktable

      # Messaging
      discord
      telegram-desktop
      element-desktop

      # Dev / productivity
      unstable.super-productivity
      mob
      lazygit
      meld
      obsidian
      jetbrains.pycharm-community
      # loaded from this flake default overlay

      # TODO: Fix cgvg
      # pkgs.cgvg-rs

    ];
  };
}
