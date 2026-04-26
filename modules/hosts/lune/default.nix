{
  config,
  inputs,
  ...
}: let
  inherit (inputs) nixpkgs determinate my-dotfiles;
in {
  flake.nixosConfigurations.lune = nixpkgs.lib.nixosSystem {
    specialArgs = {inherit my-dotfiles;};
    modules = [
      # inputs.nixosModules.overlay
      determinate.nixosModules.default

      # Main configuration, includes the hardware file and the module list
      ./configuration.nix
      ./hardware.nix

      # Main modules
      config.flake.modules.nixos.common
      config.flake.modules.nixos.graphical
    ];
  };
}
