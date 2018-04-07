{vim_configurable, vimPlugins, my_vim_config}:
 vim_configurable.customize {
    name = "v";

    # add imy custom .vimrc
    vimrcConfig.customRC = my_vim_config;

    # store your plugins in Vim packages
    vimrcConfig.packages.myVimPackage = with vimPlugins; {
      # loaded on launch
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
        ];
      # manually loadable by calling `:packadd $plugin-name`
      opt = [  ];
      # To automatically load a plugin when opening a filetype, add vimrc lines like:
      # autocmd FileType php :packadd phpCompletion
    };
 }
