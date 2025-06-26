{
  pkgs,
  my-dotfiles,
  ...
}: {
  imports = [
    ./modules/vim
    ./modules/zsh
    ./modules/ranger
    ./modules/tmux
    ./modules/emacs
    ./modules/vim-tmux-panes
    ./modules/eza
    ./modules/nushell
    ./modules/kubernetes
    ./modules/timers
    ./modules/nix-sops
  ];

  # Top level configuration for the user adfaure (me!)
  config = {
    home.stateVersion = "20.09";

    # First we activate home-manager
    programs.home-manager.enable = true;
    adfaure.services.nix-sops.enable = true;
    adfaure.home-modules.vim-tmux-nav-conf.enable = true;
    adfaure.home-modules.eza-alias.enable = true;
    adfaure.home-modules.user-timers.enable = true;

    my-programs.emacs.enable = false;
    my-programs.nushell.enable = true;

    # Small git config (should I make a dedicated module?)
    programs.git = {
      enable = true;
      difftastic.enable = true;
      userName = "Adrien Faure";
      userEmail = "adrien.faure@protonmail.com";
      aliases = {
        ds = "diff --staged";
        l = "log --pretty=format:'%C(auto,yellow)%h%C(auto,magenta) %C(auto,blue)%ad %C(auto,green)%aN %C(auto,reset)%s%C(auto)% gD%d' --graph --date=format:'%Y-%m-%d %H:%M:%S' --decorate-refs-exclude='refs/remotes/*/HEAD'";
        st = "status";
        chk = "checkout";
      };
      extraConfig = {
        # init = {
        #   defaultBranch = "master";
        # };
        # push.default = "current";
        # safe.bareRepository = "explicit";
        # rebase.instructionFormat = "%d %s";
        merge.conflictstyle = "diff3";
        # commit.verbose = true;
      };
    };

    programs.starship = {
      enable = true;
      enableNushellIntegration = true;
      catppuccin.enable = true;
      catppuccin.flavour = "frappe";

      settings = {
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
      extraConfig = builtins.readFile "${my-dotfiles}/files/ssh_config";
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
      # Python organizater
      # organize
      # Disk space vizualization
      du-dust
      # nice and fast doc
      tldr
      # better git diff
      difftastic
      ripgrep
      gh
      restic
      alsa-utils

    ];
  };
}
