{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      devShells = {
        default = pkgs.mkShell {
          packages = [
            (pkgs.python3.withPackages (ps:
              with ps; [
                pandas
              ]))
          ];
        };
      };
      formatter = nixpkgs.legacyPackages.${system}.alejandra;
    });
}
