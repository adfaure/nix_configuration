{
  config,
  lib,
  pkgs,
  my-dotfiles,
  wrapCmd,
  ...
}: let
  cfg = config.my-programs.atuin;
in {
  options = {
    my-programs.atuin = {
      enable = lib.mkOption {
        default = false;
        description = ''
          Whether to enable atuin module.
        '';
      };
    };
  };
  config = lib.mkIf cfg.enable {
    programs.atuin.enable = true;
    home.packages = [

    ];
  };
}
