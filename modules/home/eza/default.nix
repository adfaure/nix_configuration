{lib, ...}: {
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.homeManagerModules.eza;
in {
  options.homeManagerModules.eza = {
    enable = mkEnableOption "eza";
  };

  # No icons for now
  config = mkIf cfg.enable {
    programs.eza = {
      enable = true;
      icons = "auto";
    };

    home.packages = [
      # TODO: Fix fonts:
      # (builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts))
    ];
  };
}
