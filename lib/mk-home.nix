{lib}: inputs: system: username: let
  # system = "x86_64-linux";
  pkgs = import inputs.nixpkgs {
    inherit system;
  };
in
  inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = {inherit system;};

    modules = lib.mkHomeModule inputs username;
  }
