# Inspired by pkgs/applications/editors/uivonim/default.nix
# and pkgs/by-name/in/indiepass-desktop/package.nix
{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  electron,
  makeDesktopItem,
  copyDesktopItems,
}:

let
  desktopItem = makeDesktopItem {
    name = "neo";
    desktopName = "NEO";
    genericName = "Word Processor";
    comment = "A word processor for authors. Distraction-free by default.";
    exec = "neo";
    icon = "neo";
    categories = [ "Office" ];
    keywords = [
      "writing"
      "writer"
      "novel"
      "book"
      "author"
      "manuscript"
      "wordprocessor"
    ];
    terminal = false;
  };
in

buildNpmPackage rec {
  pname = "neo";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "hughhowey";
    repo = "neo";
    rev = "v1.4.7";
    sha256 = "sha256-GYtu1useZaydidhMk0g0mbOkpZYSEz85zb/9mswlV5M=";
  };

  npmDepsHash = "sha256-ox+S+j6nC6n1WrpGXDHvbY6PZbsjwKMudVI/x9VEGJE="; # you will get an error about mismatching hash the first time. Just copy the hash here

  # Useful for debugging, just run "nix-shell" and then "electron ."
  nativeBuildInputs = [
    copyDesktopItems
    electron
  ];

  desktopItems = [ desktopItem ];

  postPatch = ''
    ls -al
  '';

  # Otherwise it will try to run a build phase (via npm build) that we don't have or need, with an error:
  # Missing script: "build"
  # This method is used in pkgs/by-name/in/indiepass-desktop/package.nix
  dontNpmBuild = true;

  # Needed, otherwise you will get an error:
  # RequestError: getaddrinfo EAI_AGAIN github.com
  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
  };
  
  # The node_modules/XXX is such that XXX is the "name" in package.json
  # The path might differ, for instance in electron-forge you need build/main/main.js
  postInstall = ''
    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags $out/lib/node_modules/${pname}/main.js

    install -Dm644 build/icon.png \
      $out/share/icons/hicolor/512x512/apps/neo.png
  '';

  meta = {
    description = "Writing app for novels and screenplays";
    homepage = "https://github.com/hughhowey/neo";
    license = lib.licenses.mit;
    mainProgram = "neo";
    platforms = lib.platforms.linux;
  };
}
