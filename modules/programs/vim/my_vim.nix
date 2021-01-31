{ config, pkgs, vim_configurable, vimPlugins, my-dotfiles, ...}:
let
  vimrc = builtins.readFile "${my-dotfiles}/files/vimrc";
in

pkgs.vim_configurable.customize {

  name = "v";

  vimrcConfig.packages.myVimPackage = with pkgs.vimPlugins; {
    start = [
        meson
        # Disable YMC because it shows poor linter insights
        # youcompleteme
        fugitive
        ctrlp
        airline
        gitgutter
        # vim-easytags
        vim-misc
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
