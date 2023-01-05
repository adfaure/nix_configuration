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
    vim-fugitive

    # File explorer
    The_NERD_tree
    The_NERD_Commenter

    # Languages
    vim-markdown
    vim-orgmode
    vim-nix
    vim-go
    vim-toml

    fzf-vim
    nvim-fzf

    # better status bar
    vim-airline

    vim-trailing-whitespace
    csv

    # Python dev
    jedi-vim

    # rust
    ale
    rust-vim
  ];

  dependencies = with pkgs; [
    # For ag search command
    silver-searcher
    # For rg search command
    ripgrep
    # for coc
    nodejs
    rust-analyzer
  ];
}
