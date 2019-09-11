{ pkgs, stdenv, dmenu, python3, xorg, which }:

stdenv.mkDerivation rec {
  pname = "dmenu-setxkbmap";
  version = "0.3.0";

  buildInputs = with pkgs; [
    dmenu
    xorg.setxkbmap
    python3
    which
  ];

  src = ./.;

  patchPhase = ''
    # Patch runtime process dependencies
    sed -iE "sW\"dmenu\"W\"$(which dmenu)\"W" src/dmenu-setxkbmap.py
    sed -iE "sW\"setxkbmap\"W\"$(which setxkbmap)\"W" src/dmenu-setxkbmap.py
  '';
  installPhase = "PREFIX=$out make install";

}
