with import <nixpkgs> {};
with import <nixhome> { inherit stdenv; inherit pkgs; };
let
  dotfiles_path = "/home/${user}/dotfiles/";
in
mkHome rec {
  user = "adfaure";
  files = {

	 ".tmux.conf" = "/home/${user}/dotfiles/files/tmux.conf";

   # I don't know if I need this as I have my_vim.nix
   # ".vimrc" = "/home/${user}/dotfiles/files/vimrc";

	 ".bashrc".content = ''
	 echo use ZSH you moron!!
	 '';

   # zsh config
   ".zshrc" = "/home/${user}/dotfiles/files/zshrc";
   ".zshrc.local" = "/home/${user}/dotfiles/files/zshrc.local";

   "config/sakura/sakura.conf" = "/home/${user}/dotfiles/files";
  };
}

