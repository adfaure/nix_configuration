{ pkgs, stdenv, fetchgit, git }:

stdenv.mkDerivation rec {

  version = "0.0.1-beta";
  name = "batsite-${version}";

  buildInputs = [ pkgs.zola ];

  src = fetchgit {
    url = "https://framagit.org/adfaure/batsite";
    sha256 = "sha256-zHwX0CXNwEnFgU37x2LwGBO9H9ci/AqljxylZRtwk8I=";
    rev = "cc0f046a71afa7d19a8c796d674e89d7d49ed3e0";
  };

  checkPhase = ''
    zola check
  '';

  installPhase = ''
    zola build -o $out --base-url https://batsim.adrien-faure.fr
  '';

  meta = {
    platforms = pkgs.lib.platforms.unix;
    inherit version;
  };
}