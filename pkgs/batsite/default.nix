{ pkgs, stdenv, fetchgit, git }:

stdenv.mkDerivation rec {

  version = "0.0.1-beta";
  name = "batsite-${version}";

  buildInputs = [ pkgs.zola ];

  src = fetchgit {
    url = "https://framagit.org/adfaure/batsite";
    sha256 = "sha256-GYwx9qNAN2/LkuEwyjqTceh047rz7Yio/IRR95aTk4I=";
    rev = "70ee8cd6c62ee22f9aa8a9865e145552ce1f7c71";
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