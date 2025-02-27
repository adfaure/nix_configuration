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
      nixfmt-classic

      # GUI applications
      calibre

      spotify
      signal-desktop
      rofi
      flameshot # Screenshot

      unstable.darktable
      unstable.super-productivity

      # Messaging
      discord
      telegram-desktop
      element-desktop
      dino

      mob
      lazygit

      obsidian

      jetbrains.pycharm-community

      # loaded from this flake default overlay
      pkgs.cgvg-rs

      # # Using this for the moment ... https://github.com/NixOS/nixpkgs/issues/273611
      # (lib.throwIf (lib.versionOlder "1.4.16" pkgs.obsidian.version) "Obsidian no longer requires EOL Electron" (
      #   pkgs.obsidian.override {
      #     electron = pkgs.electron_25.overrideAttrs (_: {
      #       preFixup = "patchelf --add-needed ${pkgs.libglvnd}/lib/libEGL.so.1 $out/bin/electron"; # NixOS/nixpkgs#272912
      #       meta.knownVulnerabilities = []; # NixOS/nixpkgs#273611
      #     });
      #   }
      # ))
    ];
  };
}
