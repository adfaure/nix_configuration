{lib, ...}: {
  config,
  system,
  nixvim-config,
  ...
}: let
  cfg = config.homeManagerModules.vim;
in {
  options.homeManagerModules.vim = {
    enable = lib.mkEnableOption "vim";
  };
  config = lib.mkIf cfg.enable {
    home.packages = [
      nixvim-config.packages.${system}.default
    ];
  };
}
