{
  inputs,
  system,
  ...
}: let
  inherit (inputs) my-dotfiles nixpkgs self;
in
  nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = {inherit my-dotfiles;};
    modules = [
      self.nixosModules.overlay
      # Main configuration, includes the hardware file and the module list
      ../nixos/deployments/configuration-lune.nix
    ];
  }
