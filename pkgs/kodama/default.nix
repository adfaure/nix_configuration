{  pkgs, stdenv, fetchgit, python, go, hugo, git }:

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
in
stdenv.mkDerivation rec {

  version = "1.0.0";
  name = "kodama-${version}";

  buildInputs = [
    go
    # I use a pinned an recent hugo version,
    # it might need to be updated at some point
    (hugo.overrideAttrs (old: rec {
      pname = "hugo";
      version = "0.79.0";
      src = pkgs.fetchFromGitHub {
        owner = "gohugoio";
        repo = pname;
        rev = "v${version}";
        sha256 = "sha256:0i9c12w0jlfrqb5gygfn20rn41m7qy6ab03n779wbzwfqqz85mj6";
      };

      vendorSha256 = "0jb6aqdv9yx7fxbkgd73rx6kvxagxscrin5b5bal3ig7ys1ghpsp";
    }))
    git
  ];

  src = fetchgit {
    url = "https://gitlab.com/adfaure/kodama/";
    fetchSubmodules = true;
    sha256 = "sha256:0hncfvg9rgr7vf9j6anla0iwj6iwpp63dcfrghzajhspfjbi58a0";
    rev = "b69f15155dbf5b2524b265f02e32170e2fbd58ac";
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
    platforms = stdenv.lib.platforms.unix;
    inherit version;
  };
}

