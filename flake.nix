{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";
    # Needed to have a recent hugo version for the kodama package
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    my-dotfiles = {
      url = "github:/adfaure/dotfiles";
      flake = false;
    };
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "unstable";
    # Deployments tool for my personnal web server
    deploy-rs.url = "github:serokell/deploy-rs";
    # Secret management with sops
    sops-nix.url = "github:Mic92/sops-nix";
    # Emacs overlay
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = inputs@{ self, nixpkgs, unstable, my-dotfiles, deploy-rs, sops-nix
    , home-manager, emacs-overlay, ... }: {

      # Dedicated package for my personal website
      packages.x86_64-linux.kodama =
        with import unstable { system = "x86_64-linux"; };
        callPackage ./pkgs/kodama { };

      # Separated home-manager config for non-nixos machines.
      # Activate with: nix build .#adfaure.activationPackage; ./result/activate.
      adfaure = home-manager.lib.homeManagerConfiguration rec {
        system = "x86_64-linux";
        username = "adfaure";
        homeDirectory = "/home/${username}";
        extraSpecialArgs = { inherit nixpkgs my-dotfiles emacs-overlay; };
        configuration = {
          nixpkgs.overlays = [ emacs-overlay.overlay ];
          imports = [ ./homes/adfaure.nix ];
        };
      };

      nixosConfigurations = {
        # Configuration for my current working machine.
        roger = unstable.lib.nixosSystem {
          system = "x86_64-linux";
          # extra arguments will be injected into the modules.
          extraArgs = { inherit my-dotfiles; };
          modules = [
            # Main configuration, includes the hardware file and the module list
            ./deployments/configuration-roger.nix
          ];
        };

        # Configuration for my website server, it is supposed to be deployed with deploy-rs tool.
        # I for the moment I rely on unstable as home-manager uses features not yet available in nixos-20.09
        kodama = unstable.lib.nixosSystem {
          system = "x86_64-linux";
          # extra arguments will be injected into the modules.s
          extraArgs = {
            inherit my-dotfiles emacs-overlay;
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
            # Deploy the home-manager configuration with the home manager nixos module.
            # This enable to be set in a complete working environment when I am logging to new machines.
            home-manager.nixosModules.home-manager
            ./nixos/profiles/home-manager/adfaure.nix
          ];
        };
      };

      # This enable to bind the deploy-rs app to my flake.
      # This way I wont have version conflicts. Use with `nix run .#deploy-rs`
      apps.x86_64-linux.deploy-rs = deploy-rs.apps.x86_64-linux.deploy-rs;
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
