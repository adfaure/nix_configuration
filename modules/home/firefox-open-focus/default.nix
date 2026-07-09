{lib, ...}: {
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.homeManagerModules.firefox-open-focus;

  firefoxOpenFocus = pkgs.writeShellScriptBin "firefox-open-focus" ''
    set -euo pipefail

    ${pkgs.firefox}/bin/firefox "$@" >/dev/null 2>&1 &

    # If Firefox is already running, the URL usually opens in an existing tab.
    # Niri will not treat that as a newly opened window, so explicitly focus
    # the latest Firefox window known to Niri.
    for _ in $(${pkgs.coreutils}/bin/seq 1 60); do
      id="$(${pkgs.niri}/bin/niri msg --json windows \
        | ${pkgs.jq}/bin/jq -r '
            [.[] | select((.app_id // "") | test("firefox"; "i"))]
            | last
            | .id // empty
          ' 2>/dev/null || true)"

      if [ -n "$id" ]; then
        ${pkgs.niri}/bin/niri msg action focus-window --id "$id" >/dev/null 2>&1 || true
        exit 0
      fi

      ${pkgs.coreutils}/bin/sleep 0.05
    done
  '';
in {
  options.homeManagerModules.firefox-open-focus = {
    enable = mkEnableOption "Firefox URL handler that focuses Firefox on Niri";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.firefox
      firefoxOpenFocus
    ];

    xdg.mimeApps.enable = true;

    xdg.desktopEntries.firefox-open-focus = {
      name = "Firefox Open Focus";
      genericName = "Web Browser";
      exec = "${firefoxOpenFocus}/bin/firefox-open-focus %u";
      terminal = false;
      categories = ["Network" "WebBrowser"];
      mimeType = [
        "text/html"
        "application/xhtml+xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ];
    };

    xdg.mimeApps.defaultApplications = let
      browser = ["firefox-open-focus.desktop"];
    in {
      "text/html" = browser;
      "application/xhtml+xml" = browser;
      "x-scheme-handler/http" = browser;
      "x-scheme-handler/https" = browser;
    };
  };
}
