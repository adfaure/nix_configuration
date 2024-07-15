{
  config,
  system,
  lib,
  pkgs,
  my-dotfiles,
  nixvim-config,
  unstable,
  ...
}: {
  home.packages =
    [
      nixvim-config.packages.${system}.default
    ];
}
