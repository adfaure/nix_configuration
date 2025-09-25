{
  inputs,
  system,
  ...
}: let
  inherit (inputs) my-dotfiles nixpkgs determinate self;
in
  nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = {inherit my-dotfiles;};
    modules = [
      self.nixosModules.overlay
      determinate.nixosModules.default
      # Main configuration, includes the hardware file and the module list
      ../deployments/configuration-noco.nix
    ];
  }
