{  pkgs, stdenv, python, hugo }:

stdenv.mkDerivation rec {
  version = "0.0.a";
  name = "kodama-${version}";

  src = builtins.fetchTarball "https://gitlab.com/adfaure/kodama/-/archive/master/kodama-master.tar.gz";


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

