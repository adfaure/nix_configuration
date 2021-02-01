{ hostPkgs ? import <nixpkgs> { }, pkgs ? (let
  pinnedVersion = hostPkgs.lib.importJSON ./nixpkgs-20.09.json;
  pinnedPkgs = hostPkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs-channels";
    inherit (pinnedVersion) rev sha256;
  };
in import pinnedPkgs { }), pkgs-unstable ? (let
  pinnedVersion = hostPkgs.lib.importJSON ./nixpkgs-unstable.json;
  pinnedPkgs = hostPkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs-channels";
    inherit (pinnedVersion) rev sha256;
  };
in import pinnedPkgs { }),
# use Clang instead of GCC
useClang ? false }:
let callPackage = pkgs.lib.callPackageWith pkgs-unstable;
in rec { kodama = callPackage ./kodama { }; }
