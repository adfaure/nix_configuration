{ config, pkgs, vim_configurable, vimPlugins, ...}:
let
  vimrc = builtins.readFile(./vimrc);
in

pkgs.vim_configurable.customize {
  name = "v";

  vimrcConfig.packages.myVimPackage = with pkgs.vimPlugins; {
    start = [
        youcompleteme
        fugitive
        ctrlp
        airline
        Syntastic
        gitgutter
        The_NERD_tree
        vim-nerdtree-tabs
        vim-easytags
        vim-misc
        #LanguageClient-neovim
        rust-vim
        Tagbar
        vim-orgmode
        multiple-cursors
        gundo
        vim-nix
        vim-autoformat
        vim-go
        tmux-navigator
        rainbow_parentheses
        vim-trailing-whitespace
        vim-colorschemes
        pkgs.aspellDicts.en
        pkgs.aspellDicts.fr
        vim-grammarous
        Spacegray-vim
        # peskcolor
        csv
        LanguageClient-neovim
   ];

   opt = with pkgs.vimPlugins; [ youcompleteme fugitive elm-vim ];

  };

  # add my custom .vimrc
  vimrcConfig.customRC = vimrc;
}
