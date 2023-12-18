{
  nixpkgs,
  options,
  modulesPath,
  lib,
  config,
  pkgs,
  my-dotfiles,
  cgvg,
  ...
}: {
  imports = [
    ./base.nix
    # GUI (disabled for experiment)
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

    my-programs.emacs.enable = false;

    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
    };

    # First we activate home-manager
    programs.home-manager.enable = true;
    home.file.".config/sakura/sakura.conf".text =
      builtins.readFile "${my-dotfiles}/files/sakura.conf";

    home.packages = with pkgs; [
      bat # cat with colors for code
      cloc
      pass
      nitrokey-app
      jq
      cgvg
      tree
      pinentry
      # manpages
      wget
      direnv
    ];
  };
}
