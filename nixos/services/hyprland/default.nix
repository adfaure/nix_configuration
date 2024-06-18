{
  config,
  lib,
  pkgs,
  my-dotfiles,
  ...
}:
with lib; let
  cfg = config.adfaure.services.hyprland;
in {
  options.adfaure.services.hyprland = {
    enable = mkEnableOption "hyprland";
  };

  config = mkIf cfg.enable {
    # enable hyprland window manager
    programs.hyprland = {
      enable = true;
      # Whether to enable XWayland
      xwayland.enable = true;
    };

    environment.etc."hyprland.conf".text = builtins.readFile ./hyprland-config;

    # services.xserver = {
    #   enable = true;
    #   displayManager.sddm = {
    #     enable = true;
    #      theme = "sddm-chili";
    #     enableHidpi = true;
    #   };

    #   layout = "fr";
    #   # xkbVariant = "bepo";
    #   resolutions = [
    #     {
    #       x = 2560;
    #       y = 1440;
    #     }
    #     {
    #       x = 1920;
    #       y = 1080;
    #     }
    #   ];
    #   libinput.enable = true;
    # };

    environment.systemPackages = with pkgs; [
    ];
  };
}
