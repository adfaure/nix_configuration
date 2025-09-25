{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.adfaure.modules.enable-flake;
in {
  options.adfaure.modules.enable-flake = {
    enable = mkEnableOption "enable-flake";
  };

  config = mkIf cfg.enable {
    # https://github.com/NixOS/nix/issues/4367 I used the workaround proposed in the issue's description
    nix = {
      package = pkgs.nixFlakes; # nix-flake.packages.x86_64-linux.nix-static;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
    };
  };
}
