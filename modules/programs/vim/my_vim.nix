{ config, pkgs, vim_configurable, vimPlugins, ...}:
let
  vimrc = builtins.readFile(./vimrc);
in

pkgs.vim_configurable.customize {

  name = "v";

  vimrcConfig.packages.myVimPackage = with pkgs.vimPlugins; {
    start = [
        meson
        youcompleteme
        fugitive
        ctrlp
        airline
        gitgutter
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
        vim-colorschemes
        pkgs.aspellDicts.en
        pkgs.aspellDicts.fr
        vim-grammarous
        Spacegray-vim
        # peskcolor
        clang_complete
        csv
        LanguageClient-neovim
        rust-vim
   ];
  };

  # add my custom .vimrc
  vimrcConfig.customRC = vimrc + ''
  '' ;
}
