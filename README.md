# Nixos configuration ![example workflow](https://github.com/adfaure/nix_configuration/actions/workflows/flake-check.yml/badge.svg)
## Structure

This repository contains the nixos configurations for my machines.
The configuration uses the new flake feature (still unstable at the time).

```bash
.
├── deployments
│   ├── configuration-adchire.nix
│   ├── ...
│   ├── hardware-roger.nix
│   └── keys
├── nixos
│   ├── profiles
│   ├── programs
│   └── services
├── homes
│   ├── modules
│   ├── username2.nix
│   ├── ...
│   └── username.nix
├── pkgs
├── README.md
├── flake.lock
├── flake.nix
└── secrets.yaml
```

This folder is organized as follows:
- The folder `nixos` is divided in two categories and contains the differents module to configure nixOS machines.
    - `profiles` are higher level modules defining an ensemble of services and tools.
    - `services` for service configurations.
    - The folder `deployements` regroups the nix files used for the description of my differents system (the `configuration.nix` and `hardware.nix` files).
- `pkgs` contains the definition of my personal packages needed in the deployement such as my website.
- `homes` Contains the home manager configuration files.
- `secrets.yaml` file containing different secrets, such as password, keys etc. It works nix `sops-nix`.

## Nixos configurations

To install the configuration named `roger`:

```bash
nixos-rebuild switch --flake .#roger # as root
```

## Home manager

Home manager enables to manage dotfiles, and configure programs.
To activate my home-manager profile (named `adfaure`) run the command:

```bash
home-manager --flake .#graphical switch
```
