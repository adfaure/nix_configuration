with import <nixpkgs> {};
with import <nixhome> { inherit stdenv; inherit pkgs; };
let
  dotfiles_path = "/home/${user}/dotfiles/";
in
mkHome rec {
  user = "adfaure";
  files = {
	 ".tmux.conf" = "/home/${user}/dotfiles/files/tmux.conf";
   # ".vimrc" = "/home/${user}/dotfiles/files/vimrc";
	 ".bashrc".content = ''
	 echo use ZSH you moron!!
	 '';
  };
}

