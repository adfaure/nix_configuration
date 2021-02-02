{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";
  # Needed to have a recent hugo version for the kodama package
  inputs.unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.my-dotfiles = {
    url = "github:/adfaure/dotfiles";
    flake = false;
  };
  inputs.deploy-rs.url = "github:serokell/deploy-rs";
  outputs = { self, nixpkgs, unstable, my-dotfiles, deploy-rs, ... }: {

    # Dedicated packaging for my persoal website
    packages.x86_64-linux.kodama =
      with import unstable { system = "x86_64-linux"; };
      callPackage ./pkgs/kodama { };

    nixosConfigurations.roger = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      # extra arguments will be injected into the modules.
      extraArgs = { inherit my-dotfiles; };
      modules = [
        # Main configuration, includes the hardware file and the module list
        ./deployments/configuration-roger.nix
      ];
    };

    nixosConfigurations.vultr2 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      # extra arguments will be injected into the modules.
      extraArgs = { inherit my-dotfiles; kodama = self.packages.x86_64-linux.kodama; };
      modules = [
        # Main configuration, includes the hardware file and the module list
        ./deployments/configuration-vultr2.nix
        ({ config, ... }: { security.sudo.wheelNeedsPassword = false; })
      ];
    };

    deploy.nodes.vultr2 = {
      profiles = {
        system = {
          sshUser = "adfaure";
          path = deploy-rs.lib.x86_64-linux.activate.nixos
            self.nixosConfigurations.vultr2;
          user = "root";
        };
      };
      hostname = "140.82.57.221";
      fastConnection = true;
    };

    checks =
      builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy)
      deploy-rs.lib;
  };
}
