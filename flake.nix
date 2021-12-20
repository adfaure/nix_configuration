{
  description = "My personnal configuration";
  inputs = {
    # I need a custom nix version because of this issue: https://github.com/NixOS/nix/commit/8af4f886e212346afdd1d40789f96f1321da96c5
    nix-flake.url =
      "github:NixOS/nix?rev=8af4f886e212346afdd1d40789f96f1321da96c5";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
    # Needed to have a recent hugo version for the kodama package
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    my-dotfiles = {
      # url = "github:/adfaure/dotfiles";
      url = "/home/adfaure/Projects/dotfiles";
      # It is possible to pin the revision with:
      # To be fully reproducible, I can pin my repos
      # "github:/adfaure/dotfiles?rev=602790e25de91ae166c10b93735bbaea667f7a49";
      flake = false;
    };
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixos-unstable";
    # Deployments tool for my personnal web server
    deploy-rs.url = "github:serokell/deploy-rs";
    # Secret management with sops
    sops-nix.url = "github:Mic92/sops-nix";
    # nur-kapack = { url = "/home/adfaure/Projects/nur-kapack"; };
    nur.url = "github:nix-community/NUR";
    # Emacs overlay
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = inputs@{ self, nixpkgs, nixos-unstable, my-dotfiles, deploy-rs
    , sops-nix, home-manager, emacs-overlay, nur, nix-flake }: {

      packages.x86_64-linux = let
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
          overlays = [ emacs-overlay.overlay ];
        };
        unstable = import nixos-unstable {
          system = "x86_64-linux";
          config.allowUnfree = true;
          overlays = [ emacs-overlay.overlay ];
        };
      in {
        # Dedicated package for my personal website
        kodama = pkgs.callPackage ./pkgs/kodama { };
        batsite = pkgs.callPackage ./pkgs/batsite { };
        # Programs
        cgvg = pkgs.callPackage ./pkgs/cgvg { };
        myVscode = unstable.callPackage ./pkgs/vscode { };
        myEmacs = pkgs.callPackage ./pkgs/emacs { inherit my-dotfiles; };
        cadvisor = pkgs.callPackage ./pkgs/cadvisor { };
      };

      # Separated home-manager config for non-nixos machines.
      # Activate with: home-manager --flake .#adfaure switch
      homeConfigurations = {
        adfaure = home-manager.lib.homeManagerConfiguration rec {
          system = "x86_64-linux";
          username = "adfaure";
          homeDirectory = "/home/${username}";
          extraSpecialArgs = {
            inherit nixpkgs my-dotfiles emacs-overlay;
            cgvg = self.packages.x86_64-linux.cgvg;
          };
          configuration = {
            nixpkgs.overlays = [ self.overlay ];
            nixpkgs.config.allowUnfree = true;
            imports = [ ./homes/adfaure.nix ];
          };
        };
      };

      wsl = home-manager.lib.homeManagerConfiguration rec {
        system = "x86_64-linux";
        username = "adfaure";
        homeDirectory = "/home/${username}";
        extraSpecialArgs = {
          inherit nixpkgs my-dotfiles;
          cgvg = self.packages.x86_64-linux.cgvg;
        };
        configuration = {
          nixpkgs.overlays = [ self.overlay ];
          nixpkgs.config.allowUnfree = true;
          imports = [ ./homes/wsl.nix ];
        };
      };

      # Overlay to inject my packages in the different modules
      overlay = final: prev: {
        cadvisor = self.packages.x86_64-linux.cadvisor;
        cgvg = self.packages.x86_64-linux.cgvg;
        myVscode = self.packages.x86_64-linux.myVscode;
        myEmacs = self.packages.x86_64-linux.myEmacs;
      };

      nixosConfigurations = {
        # Configuration for my current working machine.
        roger = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          # extra arguments will be injected into the modules.
          extraArgs = { inherit my-dotfiles nur; };
          modules = [
            # Main configuration, includes the hardware file and the module list
            ./deployments/configuration-roger.nix
          ];
        };

        adchire = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          extraArgs = { inherit my-dotfiles nur; };
          modules = [
            ({ nixpkgs, lib, options, modulesPath, config, specialArgs, ... }: {
              nixpkgs.overlays = [ self.overlay ];
            })
            # Main configuration, includes the hardware file and the module list
            ./deployments/configuration-adchire.nix
          ];
        };

        # Configuration for my website server, it is supposed to be deployed with deploy-rs tool.
        # I for the moment I rely on unstable as home-manager uses features not yet available in nixos-20.09
        kodama = nixos-unstable.lib.nixosSystem {
          system = "x86_64-linux";
          # extra arguments will be injected into the modules.s
          extraArgs = {
            inherit my-dotfiles emacs-overlay;
            cgvg = self.packages.x86_64-linux.cgvg;
            kodama = self.packages.x86_64-linux.kodama;
            batsite = self.packages.x86_64-linux.batsite;
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
            ./nixos/profiles/home-manager/base.nix
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
      checks.x86_64-linux = with import nixpkgs { system = "x86_64-linux"; }; {
        cgvg = self.packages.x86_64-linux.cgvg;
        build-kodama = self.packages.x86_64-linux.kodama;

        # Deploy-rs sanity check
        inherit (builtins.mapAttrs
          (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib)
        ;
      };
    };
}
