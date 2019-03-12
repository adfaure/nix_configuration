{  pkgs, stdenv, fetchgit, python, hugo, git }:

stdenv.mkDerivation rec {

  version = "0.0.a";
  name = "kodama-${version}";

  src = fetchgit {
    url = "https://gitlab.com/adfaure/kodama/";
    fetchSubmodules = true;
    sha256 = "1fnj6m5n052l00b3760rmi9p9bnb7qvqd90q0cplmwkl1d86nyn5";
    rev = "c276fffc31d411229c2a5f32cb6304226f030dd8";
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

