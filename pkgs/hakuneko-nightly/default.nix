{
  pkgs,
  fetchurl,
}:
pkgs.hakuneko.overrideAttrs {
  src = fetchurl {
    url = "https://github.com/manga-download/hakuneko/releases/download/nightly-20200705.1/hakuneko-desktop_8.3.4_linux_amd64.deb";
    sha256 = "sha256-SOmncBVpX+aTkKyZtUGEz3k/McNFLRdPz0EFLMsq4hE=";
  };
}
