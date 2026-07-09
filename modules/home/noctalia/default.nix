{
  lib,
  inputs,
  ...
}: {
  config,
  pkgs,
  username,
  ...
}: let
  cfg = config.homeManagerModules.noctalia;
  inherit (lib) mkEnableOption;
in {
  imports = [inputs.noctalia.homeModules.default];

  options.homeManagerModules.noctalia = {
    enable = mkEnableOption "noctalia";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      brightnessctl
      cliphist
      ddcutil
      wl-clipboard
      wireplumber
    ];

    home.sessionVariables.QT_QPA_PLATFORMTHEME = "gtk3";

    gtk = {
      enable = true;
      gtk4.theme = config.gtk.theme;

      theme = {
        package = pkgs.nordic;
        name = "Nordic";
      };

      iconTheme = {
        package = pkgs.nordzy-icon-theme;
        name = "Nordzy-dark";
      };

      cursorTheme = {
        package = pkgs.nordzy-cursor-theme;
        name = "Nordzy-cursors";
        size = 24;
      };
    };

    home.pointerCursor = {
      size = 24;
      package = pkgs.nordzy-cursor-theme;
      name = "Nordzy-cursors";
      gtk.enable = true;
      x11.enable = true;
    };

    programs.noctalia-shell.enable = true;
    programs.noctalia-shell.settings =
      {
        package =
          inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default.override
          {calendarSupport = true;};
      }
      // (import ./config.nix {inherit username;});
  };
}
