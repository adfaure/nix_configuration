{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";
  inputs.my-dotfiles = {
    url = "github:/adfaure/dotfiles";
    flake = false;
  };
  outputs = { self, nixpkgs, my-dotfiles, ... }: {
    nixosConfigurations.roger = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      # extra arguments will be injected into the modules.
      extraArgs = { inherit my-dotfiles; };
      modules = [
        # Main configuration, includes the hardware file and the module list
        ./deployments/configuration-roger.nix
      ];
    };
  };
}
