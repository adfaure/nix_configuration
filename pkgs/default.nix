{ pkgs ? import <nixpkgs> {} }:
let

  callPackage = pkgs.lib.callPackageWith pkgs;

in rec {

   kodama = callPackage ./kodama {};

}
