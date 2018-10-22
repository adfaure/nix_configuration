{  pkgs, stdenv, python, hugo }:

stdenv.mkDerivation rec {
  version = "0.0.a";
  name = "kodama-${version}";

  src = pkgs.fetchgit {
    url = "https://gitlab.com/adfaure/kodama";
    rev = "d477282e07c7b525dfd5282857d2580cd198340c";
    sha256 = "0yhj5d5m8fli0nxk7wmwmmcbq020wvvbzkbl2w8vaqwvcsjgnkq0";
  };


  buildInputs = [ hugo ];

  installPhase = ''
    # install binary
    mkdir -p $out/
    hugo --config="config.toml" -s . -d $out
  '';

  meta = {
    platforms = stdenv.lib.platforms.unix;
    inherit version;
  };
}

