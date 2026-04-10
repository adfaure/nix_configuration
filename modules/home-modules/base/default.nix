{
  inputs,
  config,
  ...
}: {
  flake = {
    homeModules.base = {pkgs, ...}: {
      imports = [
        # Imported
        inputs.catppuccin.homeManagerModules.catppuccin
        inputs.sops-nix.homeManagerModules.sops

        # My modules
        config.flake.modules.homeManager.eza
        config.flake.modules.homeManager.atuin

        inputs.self.homeModules.user
        inputs.self.homeModules.graphical
        inputs.self.homeModules.nix-sops
        inputs.self.homeModules.timers
        inputs.self.homeModules.yazi
        inputs.self.homeModules.zsh
      ];

      # Top level configuration for the user adfaure (me!)
      config = {
        home.stateVersion = "20.09";

        # First we activate home-manager
        adfaure.home-modules.eza-alias.enable = true;

        # my-programs.atuin.enable = true;
        # adfaure.home-modules.vim-tmux-nav-conf.enable = true;

        adfaure.services.nix-sops.enable = true;
        adfaure.home-modules.user-timers.enable = false;

        # Small git config (should I make a dedicated module?)
        programs.home-manager.enable = true;
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
          inputs.nixvim-config.packages.${system}.default
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
        ];
      };
    };
  };
}
