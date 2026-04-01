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
    sha256 = "sha256-yvQ8vCbpNSkYObdGq9Fji/Bz2mujjZwAJIARXwtc/XU=";
  };

  cargoSha256 = "sha256-lx8M0YXLyvy2ivrIKlV8iyoy0i4pBDX2SV4boFlsNUk=";
  cargoHash = "sha256-1Op5/4g9AOHdG5BzsNMBPfOiiZYxnqIzcs9yOUU04Oo=";

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
