{pkgs}:
pkgs.hakuneko.overrideAttrs {
  src = builtins.fetchurl {
    url = "https://github.com/manga-download/hakuneko/releases/download/nightly-20200705.1/hakuneko-desktop_8.3.4_linux_amd64.deb";
    sha256 = "sha256:04g25b5jq1a1rx7ifba5qcqkyyfghi0vb6dcj29ycpv92mqagsa8";
  };
}
