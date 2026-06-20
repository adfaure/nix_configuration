{
  lib,
  inputs,
  ...
}: {
  config,
  pkgs,
  system,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.homeManagerModules.base;
in {
  options.homeManagerModules.base = {
    enable = mkEnableOption "base";
  };

  # Top level configuration for the user adfaure (me!)
  config = mkIf cfg.enable {
    home.stateVersion = "20.09";

    # Small git config (should I make a dedicated module?)
    programs.difftastic.git.enable = true;
    programs.git = {
      enable = true;
      settings = {
        user = {
          email = "adrien.faure@protonmail.com";
          name = "Adrien Faure";
        };
        rerere = {
          ebabled = 1;
        };
        alias = {
          ds = "diff --staged";
          l = "log --pretty=format:'%C(auto,yellow)%h%C(auto,magenta) %C(auto,blue)%ad %C(auto,green)%aN %C(auto,reset)%s%C(auto)% gD%d' --graph --date=format:'%Y-%m-%d %H:%M:%S' --decorate-refs-exclude='refs/remotes/*/HEAD'";
          st = "status";
          chk = "checkout";
        };
        merge.conflictstyle = "diff3";
      };
    };

    programs.starship = {
      enable = true;
      enableNushellIntegration = true;
      catppuccin.enable = true;
      catppuccin.flavour = "mocha";
      settings = {
        kubernetes = {
          disabled = false;
        };
        username = {
          disabled = false;
          show_always = true;
        };
        hostname = {
          ssh_only = false;
        };
      };
    };

    programs.ssh = {
      enableDefaultConfig = false;
      enable = true;
    };

    programs.bash = {
      enable = true;
      initExtra = ''
      '';
    };

    programs.bat = {
      enable = true;
      catppuccin.enable = true;
      catppuccin.flavour = "macchiato";
    };

    home.packages = with pkgs; [
      # Linux and dev tools
      any-nix-shell
      bat # cat with colors for code
      cloc
      unzip
      nixpkgs-review

      # system monitor
      zenith
      btop
      htop
      # Python organizater
      # organize
      # Disk space vizualization
      dust
      # nice and fast doc
      tldr
      # better git diff
      difftastic
      ripgrep
      gh
      restic
      alsa-utils
      just

      # Steelseries headset
      headsetcontrol
      protonvpn-gui
      thunderbird

      # Someday create an overlay for my packages
      inputs.self.packages."${system}".rgvg
    ];
  };
}
