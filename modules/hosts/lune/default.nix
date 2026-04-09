{inputs, ...}: let
  inherit (inputs) nixpkgs determinate my-dotfiles;
in {
  # perSystem = {system, ...}: {
  #   _module.args.pkgs = import inputs.nixpkgs {
  #     inherit system;
  #     overlays = [];
  #     config = {
  #       allowUnfree = true;
  #     };
  #   };
  # };

  flake.nixosConfigurations.lune = nixpkgs.lib.nixosSystem {
    specialArgs = {inherit my-dotfiles;};
    modules = [
      # self.nixosModules.overlay
      determinate.nixosModules.default

      # Main configuration, includes the hardware file and the module list
      ./configuration.nix
    ];
  };
}
