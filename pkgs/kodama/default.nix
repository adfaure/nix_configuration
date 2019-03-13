{  pkgs, stdenv, fetchgit, python, hugo, git }:

stdenv.mkDerivation rec {

  version = "0.0.a";
  name = "kodama-${version}";

  src = fetchgit {
    url = "https://gitlab.com/adfaure/kodama/";
    fetchSubmodules = true;
    sha256 = "1k7j91n7dghy3a7rwlg1ybhj40k8dnk9arv45s9cz2yf5zx0blnh";
    rev = "8f7d57a940d9552133885a1f6e38dd3f3ec4fc22";
    # branchName = "master";
  };

  buildInputs = [ hugo ];

  installPhase = ''
    # install binary
    mkdir -p $out/
    hugo version
    hugo --config="config/_default/config.toml" -s . -d $out
  '';

  meta = {
    platforms = stdenv.lib.platforms.unix;
    inherit version;
  };
}

