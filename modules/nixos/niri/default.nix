{lib, ...}: {
  config,
  unstable,
  pkgs,
  username,
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
    services.upower.enable = true;

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
      gnome.evolution-data-server.enable = true;
    };

    # xdg
    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-gnome
      ];
      xdgOpenUsePortal = true;

      lxqt.enable = true;
      wlr.enable = true;

      config = {
        common.default = ["gnome"];
      };
    };

    # Small module to enable niri on nixos
    programs.niri.enable = true;

    # Import home module specific to niri and noctalia
    home-manager.users.adfaure.imports = [
      {
        homeManagerModules.niri.enable = true;
        homeManagerModules.noctalia.enable = true;
      }
    ];

    environment.systemPackages = [
      pkgs.niri
      pkgs.cage
      pkgs.gtkgreet
      pkgs.xwayland-satellite
      unstable.nirimon
    ];
  };
}
