{
  pkgs,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "cgvg.rs";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "adfaure";
    repo = "${pname}";
    rev = "refs/heads/main";
    sha256 = "sha256-8rQkUGtRJ2EvAcR1KxttTjmf2UMQTpfhhyt7LHT5tRA=";
  };

  cargoSha256 = "sha256-Y5HREuHh6Q99kWK2cgzL+2q8dJEIe2HSC++F1+lFx6I=";

  meta = with pkgs.lib; {
    description = "Commandline tools for searching and browsing sourcecode";
    longDescription = ''
    '';
    homepage = "http://uzix.org/cgvg.html";
    license = licenses.gpl2;
    platforms = platforms.all;
    broken = false;
  };
}
