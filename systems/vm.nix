{
  inputs,
  system,
  unstable,
}: let
  inherit (inputs) nixpkgs home-manager catppuccin nixvim-config my-dotfiles pkgs sops-nix self;
in
  nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = {inherit my-dotfiles catppuccin nixvim-config;};
    modules = [
      # My overlay
      self.nixosModules.overlay
      # Import home-manager module
      home-manager.nixosModules.home-manager
      # top level module for this configuration
      ({modulesPath, ...}: {
        imports = [(modulesPath + "/virtualisation/qemu-vm.nix")];
        nixpkgs.hostPlatform = "x86_64-linux";
        virtualisation.memorySize = 4096;
        virtualisation.cores = 4;

        hardware.pulseaudio = {
          enable = false;
          # NixOS allows either a lightweight build (default) or full build of PulseAudio to be installed.
          # Only the full build has Bluetooth support, so it must be selected here.
          package = pkgs.pulseaudioFull;
          extraModules = [];
          extraConfig = ''
            load-module module-udev-detect ignore_dB=1
          '';
        };
      })
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;

        home-manager.users.adfaure = {...}: {
          imports = [
            sops-nix.homeManagerModules.sops
            catppuccin.homeManagerModules.catppuccin
            ../homes/graphical.nix
            ../homes/base.nix
          ];
        };

        home-manager.extraSpecialArgs = {
          inherit catppuccin unstable my-dotfiles nixvim-config system;
        };
      }
      # Default linux configuration: users, fonts etc
      ../nixos/profiles/common
      # Server X configuration, also activate i3
      ../nixos/profiles/graphical
    ];
  }
