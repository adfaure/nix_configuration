{
  pkgs,
  fetchFromGitHub,
}:
pkgs.vimUtils.buildVimPlugin {
  pname = "obsidian.nvim";
  version = "v2.5";
  src = fetchFromGitHub {
    owner = "epwalsh";
    repo = "obsidian.nvim";
    rev = "88bf9150d9639a2cae3319e76abd7ab6b30d27f0";
    hash = "sha256-irPk9iprbI4ijNUjMxXjw+DljudZ8aB3f/FJxXhFSoA=";
  };
  meta.homepage = "https://github.com/epwalsh/obsidian.nvim/";
}
