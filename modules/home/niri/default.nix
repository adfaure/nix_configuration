{lib, ...}: {
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.homeManagerModules.niri;

  ipc = args: ''spawn "noctalia-shell" "ipc" "call" ${args}'';
in {
  options.homeManagerModules.niri = {
    enable = mkEnableOption "niri";
  };

  # No icons for now
  config = mkIf cfg.enable {
    xdg.configFile."niri/config.kdl".text =
      /*
      kdl
      */
      ''
        // IDK
        spawn-at-startup "dbus-update-activation-environment" "--systemd" "WAYLAND_DISPLAY" "XDG_CURRENT_DESKTOP"
        spawn-at-startup "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        spawn-at-startup "gnome-keyring-daemon" "--start" "--components=pkcs11,secrets,ssh"
        spawn-at-startup "noctalia-shell"

        // TODO: Assumes a profile called meson has been manually configured
        spawn-at-startup "nirimon "-profile" "maison"

        input {
          keyboard {
            xkb {
              layout "fr"
            }
          }
          touchpad {
            tap
            natural-scroll
            scroll-method "two-finger"
            click-method "clickfinger"
            dwt
          }
          focus-follows-mouse max-scroll-amount="0%"
        }

        output "eDP-1" {
          scale 1.5
          variable-refresh-rate
        }

        layout {
          gaps 4
          default-column-width { proportion 0.95; }
          border {
            on
            width 2
            active-color "#4c566a"
            inactive-color "#2e3440"
          }
          focus-ring {
            off
          }
        }
        layer-rule {
          match namespace=r#"^noctalia-overview*"#
          place-within-backdrop true
        }
        window-rule {
          default-column-width { proportion 0.95; }
          geometry-corner-radius 8 8 8 8
          clip-to-geometry true
          open-fullscreen false
          open-maximized false
          open-maximized-to-edges false
        }

        prefer-no-csd

        gestures { hot-corners { off; }; }

        hotkey-overlay {
          skip-at-startup
        }

        cursor {
          xcursor-theme "Nordzy-cursors"
          xcursor-size 24
        }

        environment {
          GDK_SCALE "1"
          ELM_SCALE "1"
          QT_SCALE_FACTOR "1"
          XCURSOR_SIZE "24"
        }

        binds {
          // terminal
          Mod+T { spawn "kitty"; }

          // overview
          Mod+O { toggle-overview; }

          // noctalia shell IPC
          Alt+Return     { spawn "kitty"; }
          Mod+Space    { ${ipc ''"launcher" "toggle"''}; }
          Mod+M        { ${ipc ''"sessionMenu" "toggle"''}; }
          Ctrl+Alt+L   { ${ipc ''"lockScreen" "lock"''}; }

          // window management
          Mod+Q { close-window; }
          Mod+F { fullscreen-window; }
          Mod+Z { toggle-window-floating; }
          Mod+A { center-column; }
          Mod+X { consume-or-expel-window-left; }

          // focus
          Mod+H { focus-column-left; }
          Mod+L { focus-column-right; }
          Mod+K { focus-window-or-workspace-up; }
          Mod+J { focus-window-or-workspace-down; }

          // move window
          Mod+Ctrl+H { move-column-left; }
          Mod+Ctrl+L { move-column-right; }
          Mod+Ctrl+K { move-window-up-or-to-workspace-up; }
          Mod+Ctrl+J { move-window-down-or-to-workspace-down; }

          // focus monitor
          Mod+Shift+H { focus-monitor-left; }
          Mod+Shift+L { focus-monitor-right; }
          Mod+Shift+K { focus-monitor-up; }
          Mod+Shift+J { focus-monitor-down; }

          // move window to monitor
          Mod+Ctrl+Shift+H { move-window-to-monitor-left; }
          Mod+Ctrl+Shift+L { move-window-to-monitor-right; }
          Mod+Ctrl+Shift+K { move-window-to-monitor-up; }
          Mod+Ctrl+Shift+J { move-window-to-monitor-down; }

          // move workspace to monitor
          Mod+Left  { move-workspace-to-monitor-left; }
          Mod+Right { move-workspace-to-monitor-right; }
          Mod+Up    { move-workspace-to-monitor-up; }
          Mod+Down  { move-workspace-to-monitor-down; }

          // resize column width / window height
          Mod+Ctrl+Left  { set-column-width "-5%"; }
          Mod+Ctrl+Right { set-column-width "+5%"; }
          Mod+Ctrl+Up    { set-window-height "-5%"; }
          Mod+Ctrl+Down  { set-window-height "+5%"; }

          // workspaces
          Mod+ampersand { focus-workspace 1; }
          Mod+eacute { focus-workspace 2; }
          Mod+quotedbl { focus-workspace 3; }
          Mod+apostrophe { focus-workspace 4; }
          Mod+parenleft { focus-workspace 5; }
          Mod+minus { focus-workspace 6; }
          Mod+egrave { focus-workspace 7; }
          Mod+underscore { focus-workspace 8; }
          Mod+ccedilla { focus-workspace 9; }
          Mod+agrave { focus-workspace 10; }

          Mod+Ctrl+ampersand { move-window-to-workspace 1; }
          Mod+Ctrl+eacute { move-window-to-workspace 2; }
          Mod+Ctrl+quotedbl { move-window-to-workspace 3; }
          Mod+Ctrl+apostrophe { move-window-to-workspace 4; }
          Mod+Ctrl+parenleft { move-window-to-workspace 5; }
          Mod+Ctrl+minus { move-window-to-workspace 6; }
          Mod+Ctrl+egrave { move-window-to-workspace 7; }
          Mod+Ctrl+underscore { move-window-to-workspace 8; }
          Mod+Ctrl+ccedilla { move-window-to-workspace 9; }
          Mod+Ctrl+agrave { move-window-to-workspace 10; }

          // media keys via noctalia IPC
          XF86AudioMute         { ${ipc ''"volume" "muteOutput"''}; }
          XF86AudioRaiseVolume  { ${ipc ''"volume" "increase"''}; }
          XF86AudioLowerVolume  { ${ipc ''"volume" "decrease"''}; }
          XF86AudioPrev         { ${ipc ''"media" "previous"''}; }
          XF86AudioPlay         { ${ipc ''"media" "playPause"''}; }
          XF86AudioNext         { ${ipc ''"media" "next"''}; }
          XF86MonBrightnessUp   { ${ipc ''"brightness" "increase"''}; }
          XF86MonBrightnessDown { ${ipc ''"brightness" "decrease"''}; }

          // screenshots
          Mod+Shift+eacute { screenshot-screen; } // 2
          Mod+Shift+parenleft { screenshot-window; } // 5

          Print { screenshot; };
        }
      '';

    home.packages = [
      pkgs.alacritty
      pkgs.xev

      # File explorer
      pkgs.nemo
    ];
  };
}
