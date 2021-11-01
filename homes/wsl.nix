{ nixpkgs, options, modulesPath, lib, config, pkgs, my-dotfiles, cgvg, ... }: {

  imports = [
    ./base.nix

    # GUI (disabled for experiment)
    # ./modules/emacs
    ./modules/vim
  ];



  # Top level configuration for the user adfaure (me!)
  config = {

    programs.bash = {
      bashrcExtra = ''
        .  /home/adfaure/.nix-profile/etc/profile.d/nix.sh
        # Replace current shell with zsh
        exec zsh
        '';
    };

    # First we activate home-manager
    programs.home-manager.enable = true;
    home.file.".config/sakura/sakura.conf".text =
      builtins.readFile "${my-dotfiles}/files/sakura.conf";

    home.packages = with pkgs; [
      bat # cat with colors for code
      cloc
      pass
      taskwarrior
      timewarrior
      nitrokey-app
      jq
      cgvg
      tree
      manpages
      gcc
      wget
      gdb
      direnv
      entr

      # Nix file formating
      nixfmt
    ];
  };
}
