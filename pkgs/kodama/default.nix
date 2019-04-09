{  pkgs, stdenv, fetchgit, python, hugo, git }:

stdenv.mkDerivation rec {

  version = "0.0.a";
  name = "kodama-${version}";

  src = fetchgit {
    url = "https://gitlab.com/adfaure/kodama/";
    fetchSubmodules = true;
    sha256 = "0arw6vklmyxc7xvijz0x2i3qshi73jy1ahc8n9b9r89bq5fvszvw";
    rev = "8188d9ea49822ada1d00f42dd3d90db059b3e5cd";
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

