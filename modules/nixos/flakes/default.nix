{lib, ...}: {config, ...}:
with lib; let
  cfg = config.nixosModules.flakes;
in {
  options.nixosModules.flakes = {
    enable = mkEnableOption "flakes";
  };

  config = mkIf cfg.enable {
    # https://github.com/NixOS/nix/issues/4367 I used the workaround proposed in the issue's description
    nix = {
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
    };
  };
}
