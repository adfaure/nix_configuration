{lib, ...}: {config, ...}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.homeManagerModules.atuin;
in {
  options = {
    homeManagerModules.atuin = {
      enable = mkEnableOption "atuin";
    };
  };
  config = mkIf cfg.enable {
    programs.atuin.enable = true;
    programs.atuin.settings = {
      enter_accept = false;
      keymap_mode = "vim-normal";
    };
    home.packages = [
    ];
  };
}
