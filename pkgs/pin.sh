#!/usr/bin/env bash
nix-prefetch-git https://github.com/nixos/nixpkgs-channels.git \
refs/heads/nixos-19.03 > nixpkgs-19.03.json
