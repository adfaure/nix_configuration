{ pkgs, config, my-dotfiles, ... }: {

  imports = [ ./modules/emacs ./modules/vim ./modules/zsh ./modules/ranger ];

  config = {
    # Small git config (should I make a dedicated module?)
    programs.git = {
      enable = true;
      userName = "adfaure";
      userEmail = "adrien.faure@protonmail.com";
    };
    home.stateVersion = "20.09";
    home.username = "adfaure";
    home.homeDirectory = "/home/adfaure";
    programs.home-manager.enable = true;

    home.packages = with pkgs; [ evince ];
  };
}
