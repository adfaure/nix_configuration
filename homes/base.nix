{ nixpkgs, options, modulesPath, lib, config, pkgs, my-dotfiles, emacs-overlay
, cgvg, ... }: {

  imports = [
    ./modules/vim
    ./modules/zsh
    ./modules/ranger
    ./modules/emacs
    ./modules/tmux
  ];

  # Top level configuration for the user adfaure (me!)
  config = {
    home.stateVersion = "20.09";

    # First we activate home-manager
    programs.home-manager.enable = true;
    # Small git config (should I make a dedicated module?)
    programs.git = {
      enable = true;
      userName = "Adrien Faure";
      userEmail = "adrien.faure@protonmail.com";
      aliases = {
        ds = "diff --staged";
        l =
          "log --pretty=format:'%C(auto,yellow)%h%C(auto,magenta) %C(auto,blue)%ad %C(auto,green)%aN %C(auto,reset)%s%C(auto)% gD%d' --graph --date=format:'%Y-%m-%d %H:%M:%S' --decorate-refs-exclude='refs/remotes/*/HEAD'";
        st = "status";
        chk = "checkout";
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

    # home.username = "adfaure";
    # home.homeDirectory = "/home/adfaure";

    home.file.".tmux".text = builtins.readFile "${my-dotfiles}/files/tmux";

    home.packages = with pkgs; [
      # Linux and dev tools
      any-nix-shell
      bat # cat with colors for code
      cloc
    ];
  };
}
