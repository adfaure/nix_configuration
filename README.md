# Nixos configuration ![example workflow](https://github.com/adfaure/nix_configuration/actions/workflows/flake-check.yml/badge.svg)

## Nixos configurations

To install the configuration named `lune`:

```bash
nixos-rebuild switch --flake .#lune # as root
```

## Home manager

Home manager enables to manage dotfiles, and configure programs.
To activate my home-manager profile (named `adfaure`) run the command:

```bash
home-manager --flake .#graphical switch
```
