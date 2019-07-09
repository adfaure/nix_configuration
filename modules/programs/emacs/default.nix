{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.environment.adfaure.programs.emacs;
in
{
  options.environment.adfaure.programs.emacs = {
    enable = mkEnableOption "emacs";
  };

  config = mkIf config.environment.adfaure.programs.emacs.enable rec {

    environment.systemPackages = [
      (pkgs.callPackage ./my_emacs.nix { })
    ];
  };
}
