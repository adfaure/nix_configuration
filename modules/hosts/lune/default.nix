{
  config,
  inputs,
  ...
}: let
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
      {
        # system = "x86_64-linux";
        # pkgs = import config.nixpkgs {
        #   inherit (config) system;
        #   config.allowUnfree = true;
        # };
        # finalPackage = self.nixosConfigurations.${name}.config.system.build.toplevel;

        # modules = [
        #   config.flake.modules.nixos.core
        #   { networking.hostName = name; }
        # ];
      }
      # inputs.nixosModules.overlay
      determinate.nixosModules.default

      # Main configuration, includes the hardware file and the module list
      ./configuration.nix
      config.flake.modules.nixos.common
    ];
  };
}
