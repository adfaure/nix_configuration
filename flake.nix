{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";
  # Needed to have a recent hugo version for the kodama package
  inputs.unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.my-dotfiles = {
    url = "github:/adfaure/dotfiles";
    flake = false;
  };
  # Deployments tool for my personnal web server
  inputs.deploy-rs.url = "github:serokell/deploy-rs";
  # Secret management with sops
  inputs.sops-nix.url = "github:Mic92/sops-nix";
  outputs =
    { self, nixpkgs, unstable, my-dotfiles, deploy-rs, sops-nix, ... }: {

      # Dedicated package for my personal website
      packages.x86_64-linux.kodama =
        with import unstable { system = "x86_64-linux"; };
        callPackage ./pkgs/kodama { };

      # Configuration for my current working machine.
      nixosConfigurations.roger = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # extra arguments will be injected into the modules.
        extraArgs = { inherit my-dotfiles; };
        modules = [
          # Main configuration, includes the hardware file and the module list
          ./deployments/configuration-roger.nix
        ];
      };

      # Configuration for my website server
      # It is supposed to be deployed with deploy-rs tool.
      # However, it is a normal nixos configuration.
      nixosConfigurations.kodama = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # extra arguments will be injected into the modules.
        extraArgs = {
          inherit my-dotfiles;
          kodama = self.packages.x86_64-linux.kodama;
        };
        modules = [
          # Main configuration, includes the hardware file and the module list.
          ./deployments/configuration-kodama.nix
          # Install sops-nix.
          sops-nix.nixosModules.sops
          # Secrets configuration with sops.
          ({ config, ... }: {
            # The default file containing the secrets.
            sops.defaultSopsFile = ./secrets.yaml;
            # We tell sops-nix which secrets we use.
            sops.secrets.radicaleUsers = { };
            # This part is required to enable nginx to access to the decrypted file.
            systemd.services.nginx = {
              serviceConfig.SupplementaryGroups =
                [ config.users.groups.keys.name ];
            };
            sops.secrets.radicaleUsers.owner = config.users.users.nginx.name;
          })
        ];
      };

      # deploy-rs configuration to deploy kodama.
      deploy.nodes.kodama = {
        profiles = {
          system = {
            sshUser = "adfaure";
            path = deploy-rs.lib.x86_64-linux.activate.nixos
              self.nixosConfigurations.kodama;
            # This suppose that the ssh user can use sudo without password.
            user = "root";
          };
        };
        # The at this hostname must be running NixOS.
        hostname = "adrien-faure.fr";
        fastConnection = true;
      };

      # Sanity check for deploy-rs
      checks = builtins.mapAttrs
        (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
