{lib, ...}: {
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.nixosModules.nix-ld;
in {
  options.nixosModules.nix-ld = {
    enable = mkEnableOption "nix-ld";
  };

  config = mkIf cfg.enable {
    programs.nix-ld = {
      enable = true;

      libraries = with pkgs; [
        stdenv.cc.cc.lib
        zlib
      ];
    };
  };
}
