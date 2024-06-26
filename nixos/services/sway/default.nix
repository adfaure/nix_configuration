{
  config,
  lib,
  pkgs,
  my-dotfiles,
  ...
}:
with lib; let
  cfg = config.adfaure.services.sway;

  sddm-theme-chili = pkgs.stdenv.mkDerivation rec {
    name = "sddm-chili";

    src = pkgs.fetchFromGitHub {
      owner = "MarianArlt";
      repo = name;
      rev = "6516d50176c3b34df29003726ef9708813d06271";
      sha256 = "sha256-wxWsdRGC59YzDcSopDRzxg8TfjjmA3LHrdWjepTuzgw=";
    };

    installPhase = ''
      mkdir $out/share/sddm/themes/${name} -p
      cp ${src}/* $out/share/sddm/themes/${name}/. -aR
    '';

    meta = with lib; {
      description = "Theme for SDDM";
      homepage = "https://github.com/MarianArlt/sddm-chili";
      license = licenses.gpl3Only;
      maintainers = with maintainers; [dan4ik605743];
      platforms = platforms.linux;
    };
  };

  # i3conf = builtins.readFile "${my-dotfiles}/files/i3";
  # bash script to let dbus know about important env variables and
  # propogate them to relevent services run at the end of sway config
  # see
  # https://github.com/emersion/xdg-desktop-portal-wlr/wiki/"It-doesn't-work"-Troubleshooting-Checklist
  # note: this is pretty much the same as  /etc/sway/config.d/nixos.conf but also restarts
  # some user services to make sure they have the correct environment variables
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

  # currently, there is some friction between sway and gtk:
  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
  # the suggested way to set gtk settings is with gsettings
  # for gsettings to work, we need to tell it where the schemas are
  # using the XDG_DATA_DIR environment variable
  # run at the end of sway config
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme 'Dracula'
    '';
  };

  waybar-media = pkgs.waybar.override {withMediaPlayer = true;};
  waybar-with-conf =
    pkgs.writeShellScriptBin
    "waybar-with-conf"
    "${waybar-media}/bin/waybar --config ${my-dotfiles}/files/waybar/config --style ${my-dotfiles}/files/waybar/style.css";
in {
  options.adfaure.services.sway = {
    enable = mkEnableOption "sway";
  };

  config = mkIf cfg.enable {
    # enable sway window manager
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };

    services.xserver = {
      enable = true;
      displayManager.sddm = {
        enable = true;
        theme = "sddm-chili";
        enableHidpi = true;
      };

      layout = "fr";
      # xkbVariant = "bepo";
      resolutions = [
        {
          x = 2560;
          y = 1440;
        }
        {
          x = 1920;
          y = 1080;
        }
      ];
      libinput.enable = true;
    };

    environment.systemPackages = with pkgs; [
      blueman
      rxvt_unicode
      # Batery info
      acpi
      # controle media player
      playerctl
      pamixer
      wirelesstools
      networkmanager_dmenu
      sysstat

      bemenu # wayland clone of dmenu
      mako # notification system developed by swaywm maintainer

      rofi

      configure-gtk
      wayland
      glib # gsettings
      dracula-theme # gtk theme
      gnome3.adwaita-icon-theme # default gnome cursors
      sway
      swaylock
      swayidle
      swaybg
      wl-clipboard
      swaylock-fancy
      sway-contrib.grimshot
      dbus-sway-environment

      waybar-with-conf
      waybar

      sddm-theme-chili

      libsForQt5.plasma-framework
      libsForQt5.qt5.qtgraphicaleffects

      wdisplays
    ];
  };
}
