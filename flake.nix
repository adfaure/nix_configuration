{
  # Needed to have a recent hugo version for the kodama package
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    my-dotfiles = {
      url = "github:/adfaure/dotfiles";
      flake = false;
    };
    home-manager.url = "github:nix-community/home-manager";
    # Deployments tool for my personnal web server
    deploy-rs.url = "github:serokell/deploy-rs";
    # Secret management with sops
    sops-nix.url = "github:Mic92/sops-nix";
    # Emacs overlay
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = { self, nixpkgs, unstable, my-dotfiles, deploy-rs, sops-nix
    , home-manager, emacs-overlay, ... }: {

      # Dedicated package for my personal website
      packages.x86_64-linux.kodama =
        with import unstable { system = "x86_64-linux"; };
        callPackage ./pkgs/kodama { };

      # Configuration for my current working machine.
      # Currently using nixos-unstable
      nixosConfigurations.roger = unstable.lib.nixosSystem {
        system = "x86_64-linux";
        # extra arguments will be injected into the modules.
        extraArgs = { inherit my-dotfiles; };
        modules = [
          home-manager.nixosModules.home-manager
          ({ lib, my-dotfiles, ... }: {
            nixpkgs.overlays = [ emacs-overlay.overlay ];

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # home-manager.options.extraSpecialArgs = { inherit my-dotfiles; };
            home-manager.users.adfaure = { ... }: {
              imports = [
                # This module enables to inject my-dotfiles into the home-manager modules.
                ({ ... }: { _module.args.my-dotfiles = my-dotfiles; })
                ./homes/adfaure.nix
              ];
            };
          })
          # Main configuration, includes the hardware file and the module list
          ./deployments/configuration-roger.nix
        ];
      };

      # Configuration for my website server
      # It is supposed to be deployed with deploy-rs tool.
      # However, it is a normal nixos configuration.
      nixosConfigurations.kodama = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # extra arguments will be injected into the modules.s
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
