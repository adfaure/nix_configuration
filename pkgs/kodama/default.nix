{  pkgs, stdenv, fetchgit, python, hugo, git }:

stdenv.mkDerivation rec {

  version = "0.0.b";
  name = "kodama-${version}";

  src = fetchgit {
    url = "https://gitlab.com/adfaure/kodama/";
    fetchSubmodules = true;
    sha256 = "sha256:1vwm8ij1p6k1p7sadhab8rwcpp1icllvz755lcw0z3i68cpw4v9v";
    rev = "9aee84a313cdd3c665594507c38a0fc075f67852";
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

