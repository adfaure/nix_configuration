{ pkgs, stdenv, fetchgit, go, hugo, git }:

# Packaging of my hugo website
# I did some ugly hacks to prevent hugo from trying to clone repository from github wich is not
# allowed by nix.

let
  # Wowchemy is the module hugo wants to download so I get it from github
  wowchemy = pkgs.fetchFromGitHub {
    owner = "wowchemy";
    repo = "wowchemy-hugo-modules";
    rev = "86da39719ccd0cb1348f33c8c6c03fd0c3a93686";
    sha256 = "sha256:19cdhmf7m3qw4z8s68nkzhv3x9dwslfn9901d0qmnzgwlywx3jiz";
  };
in stdenv.mkDerivation rec {

  version = "1.0.0";
  name = "kodama-${version}";

  buildInputs = [
    go
    hugo
    git
  ];

  src = fetchgit {
    url = "https://gitlab.com/adfaure/kodama/";
    fetchSubmodules = true;
    sha256 = "sha256:0gckxh068dsj4izpa0cv69mfikh3s1ccz68jhgcsb4ia8wanygkm";
    rev = "0b6eeecae7d6dbb109f343a1b0d7b9d5fbc7bc5f";
  };

  # This is the configure phase, were I manually install the wowchemy module
  configurePhase = ''
    # First I put the wowchemy directory where hugo wants it
    mkdir -p themes/github.com/wowchemy/wowchemy-hugo-modules/
    cp -r  ${wowchemy}/wowchemy themes/github.com/wowchemy/wowchemy-hugo-modules/

    # Then, I have to remove the go.sum and go.mod so hugo doesn't try to
    # (re)-download wowchemy.
    # It will cause hugo to look in the target folder, instead of dowloading it
    rm -r go.mod
    rm -r go.sum
  '';

  installPhase = ''
    hugo --config="config/_default/config.toml" -s . -d $out
  '';

  meta = {
    platforms = pkgs.lib.platforms.unix;
    inherit version;
  };
}

