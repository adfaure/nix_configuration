#!/usr/bin/env bash
nix-prefetch-git https://github.com/nixos/nixpkgs.git \
refs/heads/nixos-20.03 > nixpkgs-20.03.json
