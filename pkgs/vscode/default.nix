{
  config,
  lib,
  pkgs,
  ...
}: let
  # vscode_packages.nix can be generated with a script available in nixpgks
  # ./pkgs/misc/vscode-extensions/update_installed_exts.sh > vscode_packages.nix
  extensions =
    pkgs.vscode-utils.extensionsFromVscodeMarketplace
    (import ./vscode_packages.nix).extensions;
in
  pkgs.vscode-with-extensions.override {vscodeExtensions = extensions ++ [ pkgs.vscode-extensions.rust-lang.rust-analyzer ];}


