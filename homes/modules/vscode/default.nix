{ config, lib, pkgs, my-dotfiles, ... }:
let
  extensions = (with pkgs.vscode-extensions; [
    # Languages support
    bbenoist.Nix
    ms-python.python
    dhall.dhall-lang

    # Themes
    pkief.material-icon-theme

    # Tools
    streetsidesoftware.code-spell-checker
    # ms-vscode-remote.remote-ssh
    ms-azuretools.vscode-docker
    eamodio.gitlens

    # Vim mode
    vscodevim.vim
  ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    # Languages support
    {
      name = "org-mode";
      publisher = "tootone";
      version = "0.5.0";
      sha256 = "sha256-vXwo3oFLwK/wY7XEph9lGvXYIxjZsxeIE4TVAROmV2o=";
    }
    {
      name = "vscode-perl";
      publisher = "cfgweb";
      version = "1.18.0";
      sha256 = "sha256-dWCH3Odj2e2pQ/EkLcEOsQM2AsSIper+TVd3VCb8yeE=";
    }
    {
      name = "rust";
      publisher = "rust-lang";
      version = "0.7.0";
      sha256 = "sha256-QPO5IA5mrYo6cn3hdTjmzhbRN/YU7G4yMspJ+dRBx5o=";
    }
    {
      name = "mypy";
      publisher = "matangover";
      version = "0.1.5";
      sha256 = "sha256-/cI/fj4gtm/eTiNN48WPnpq5c3Led0Azi24YWO4BowE=";
    }
    # Theme and appearance
    {
      name = "non-breaking-space-highlighter";
      publisher = "viktorzetterstrom";
      version = "0.0.3";
      sha256 = "sha256-t+iRBVN/Cw/eeakRzATCsV8noC2Wb6rnbZj7tcZJ/ew=";
    }
    {
      name = "trailing-spaces";
      publisher = "shardulm94";
      version = "0.3.1";
      sha256 = "sha256-aCFtiONPjKewzOl7cRoQegU2J/6+5Cbn2ezgXF79YEA=";
    }
    {
      name = "trailing-spaces";
      publisher = "shardulm94";
      version = "0.3.1";
      sha256 = "sha256-aCFtiONPjKewzOl7cRoQegU2J/6+5Cbn2ezgXF79YEA=";
    }
    {
      publisher = "vscode-icons-team";
      name = "vscode-icons";
      version = "11.4.0";
      sha256 = "sha256-SZsGot8qTmzqOeP2KUga/tb2vUmyugz4uizRR0qxvn0=";
    }
  ];

  vscode-with-extensions =
    pkgs.vscode-with-extensions.override { vscodeExtensions = extensions; };
in {

  home.packages = [ vscode-with-extensions pkgs.ctags ];
}