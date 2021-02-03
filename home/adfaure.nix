{ pkgs, config, my-dotfiles, ... }: {

  imports = [
    #./modules/vim.nix
    # ./modules/emacs
    ./modules/vim
    ./modules/zsh
    # ./modules/ranger
  ];

  config = {
    home.packages = with pkgs;
      [
        #(pkgs.callPackage /home/joerg/git/nix-review {})
        python
      ];

    home.stateVersion = "20.09";
    home.username = "adfaure";
    home.homeDirectory = "/home/adfaure";

    programs.home-manager.enable = true;
  };
}
