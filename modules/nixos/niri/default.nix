{lib, ...}: {
  config,
  unstable,
  pkgs,
  ...
}:
with lib; let
  cfg = config.nixosModules.niri;
in {
  options.nixosModules.niri = {
    enable = mkEnableOption "niri";
  };

  config = mkIf cfg.enable {
    # login manager: use gtkgreet, and use gtklock for locker
    services.greetd = {
      enable = true;
      settings.default_session = {
        user = "greeter";
        command = lib.concatStringsSep " " [
          "${pkgs.cage}/bin/cage"
          "-s"
          "-d"
          "-m"
          "last"
          "--"
          "${pkgs.gtkgreet}/bin/gtkgreet"
          "-c"
          "niri-session"
        ];
      };
    };

    environment.variables = {
      GDK_BACKEND = "wayland";
      LIBSEAT_BACKEND = "logind";
      MOZ_ENABLE_WAYLAND = 1;
      MOZ_WEBRENDER = 1;
      NIXOS_OZONE_WL = 1;
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
      SDL_VIDEODRIVER = "wayland";
      _JAVA_AWT_WM_NONREPARENTING = 1;
    };

    # Noctalia needs it
    services.power-profiles-daemon.enable = true;

    # locker
    security.pam.services.gtklock = {};
    security.pam.services.login.enableGnomeKeyring = true;
    security.pam.services.greetd.enableGnomeKeyring = true;
    security.pam.services.greetd.fprintAuth = false;

    # gnome polkit and keyring
    security.polkit.enable = true;

    services = {
      dbus.packages = with pkgs; [gcr];
      gnome.gnome-keyring.enable = true;
    };

    # xdg
    xdg.portal = {
      enable = true;
      lxqt.enable = true;
      wlr.enable = true;
      config.common.default = "*";
    };

    # Small module to enable niri on nixos
    programs.niri.enable = true;
    environment.systemPackages = [
      pkgs.niri
      pkgs.cage
      pkgs.gtkgreet
      pkgs.xwayland-satellite
      unstable.nirimon
    ];
  };
}
