# Nixos configuration

## Structures

This repository contains the nixos configurations for my machines.
The configuration uses the new flake feature (still unstable at the time).

```bash
.
├── deployments
│   ├── configuration-adchire.nix
│   ├── ...
│   ├── hardware-roger.nix
│   └── keys
├── modules
│   ├── profiles
│   ├── programs
│   └── services
├── pkgs
├── README.md
├── flake.lock
├── flake.nix
└── secrets.yaml
```

This folder is organized as follows:
- The folder `deployements` regroups the nix files used for the description of my differents system (the `configuration.nix` and `hardware.nix` files).
- The folder `modules` is divided in three categories.
	- `profiles` are higher level modules defining an ensemble of services and tools.
	- In `programs` are defined modules configuring a program, such as vim or emacs etc. Importing one of this module in your main configuration will install the program defined in.
	- `services` for service configurations.
- `pkgs` contains the definition of my personal packages needed in the deployement such as my website.
- `secrets.yaml` file containing different secrets, such as password, keys etc. It works nix `sops-nix`.

## How to use it

To install the configuration named `roger`:

```bash
nixos-rebuild switch --flake .#roger # as root
```

# Cloud nodes

## Configure and deploy

This project uses `deploy-rs` to deploy my website.

Create a shell with `deploy`.
```bash
nix shell github:serokell/deploy-rs
```

To deploy use the command: `deploy` (yeah, no kidding).

## Secret management

The secrets are managed with `sops-nix`.
