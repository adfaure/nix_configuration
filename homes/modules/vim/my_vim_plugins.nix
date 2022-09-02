{
  pkgs,
  vimPlugins,
  vimUtils,
}: {
  plugins = with vimPlugins; [
    # Monokai theme
    vim-monokai
    # lib for some plugins
    vim-misc
    # Multi vim cursor
    vim-visual-multi

    # Dicionnary
    pkgs.aspellDicts.en
    pkgs.aspellDicts.fr

    # find files
    ctrlp

    # gitgutter
    gitgutter

    # File explorer
    The_NERD_tree
    The_NERD_Commenter


    # Languages
    vim-markdown
    vim-orgmode
    vim-nix
    vim-go
    vim-toml

    # better status bar
    vim-airline

    vim-trailing-whitespace

    csv

    # Buggy in 22.05
    # # bug: neovim: rebuilding with coc support does not work when nodejs is in PATH
    # https://github.com/nix-community/home-manager/issues/2966
    # coc-nvim
    coc-yaml
    coc-json
    coc-html
    coc-css
  ];

  dependencies = with pkgs; [
    # for coc
    nodejs
  ];
}
