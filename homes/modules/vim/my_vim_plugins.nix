{
  pkgs,
  vimPlugins,
  vimUtils,
  unstable,
}: {
  plugins = with vimPlugins; [
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

    ale # LSP
    deoplete-nvim # Completion

    # Languages
    vim-markdown
    vim-nix
    vim-go
    vim-toml
    typst-vim
    # rust-vim
    jedi-vim # Python

    fzf-vim
    nvim-fzf

    # better status bar
    vim-airline

    vim-trailing-whitespace
    csv

    # Obsidian
    {
      plugin = pkgs.obsidian-nvim;
      type = "lua";
    }
    # Obsidian dep
    plenary-nvim
  ];

  dependencies = with pkgs; [
    # For ag search command
    silver-searcher
    # For rg search command
    ripgrep
    # for coc
    # nodejs
    rust-analyzer
    # (python3.withPackages(ps: [
    #   ps.python-lsp-server ps.pyls-flake8]))
  ];
}
