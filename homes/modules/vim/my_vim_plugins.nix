{ pkgs, vimPlugins, vimUtils }: {
  plugins = with vimPlugins; [
    # airline
    # vim-easytags
    vim-misc
    multiple-cursors
    gundo
    vim-colorschemes
    pkgs.aspellDicts.en
    pkgs.aspellDicts.fr
    clang_complete
    rust-vim
    fugitive
    ctrlp
    # airline
    Syntastic
    gitgutter
    The_NERD_tree
    The_NERD_Commenter
    LanguageClient-neovim
    Tagbar
    vim-orgmode
    vim-visual-multi
    vim-nix
    vim-autoformat
    vim-go
    tmux-navigator
    rainbow_parentheses
    vim-trailing-whitespace
    vim-grammarous
    csv
    Spacegray-vim
    gruvbox
    coc-nvim
    coc-yaml
    coc-json
    coc-html
    coc-css
    vim-toml
  ];

  dependencies = with pkgs; [
    # Vim config dependencies
    rustup
    go-langserver
    llvmPackages.libclang
    ccls
    # For coc
    nodejs
    # NOT WORKING DUE TO sha256 mismatch
    #(nur.repos.mic92.nix-lsp.overrideAttrs (attr: {
    #  cargoSha256 = "13fhaspvrgymbbr230j41ppbz3a5qm12xl667cs7x888h0jvsp5g";
    #}))
    (python3.withPackages (ps:
      with ps; [
        python-language-server
        # the following plugins are optional, they provide type checking, import sorting and code formatting
        black
        jedi
        pylama
        flake8
        isort
      ]))
  ];
}
