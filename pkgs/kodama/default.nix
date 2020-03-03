{  pkgs, stdenv, fetchgit, python, hugo, git }:

stdenv.mkDerivation rec {

  version = "0.0.b";
  name = "kodama-${version}";

  src = fetchgit {
    url = "https://gitlab.com/adfaure/kodama/";
    fetchSubmodules = true;
    sha256 = "sha256:0f1hrv34izz1c4n12qrs5nl7rh4hzla4lqzgzp2bkcjv5705mp1s";
    rev = "575fa40adc8210c41b9df63b0f1974626084c143";
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

