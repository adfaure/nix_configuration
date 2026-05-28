{
  lib,
  inputs,
  ...
}: {config, system, ...}: let
  cfg = config.homeManagerModules.vim;
in {
  options.homeManagerModules.vim = {
    enable = lib.mkEnableOption "vim";
  };
  config = lib.mkIf cfg.enable {
    home.packages = [
      inputs.nixvim-config.packages.${system}.default
    ];
  };
}
