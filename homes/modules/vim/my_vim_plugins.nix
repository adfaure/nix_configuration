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
  ];

  dependencies = with pkgs; [
    # for coc
    nodejs
  ];
}
