{ config, lib, pkgs, my-dotfiles, ... }:

with lib;
let cfg = config.environment.adfaure.programs.emacs;
in {
  environment.systemPackages =
    [ (pkgs.callPackage ./my_emacs.nix { inherit my-dotfiles; }) ];
}
