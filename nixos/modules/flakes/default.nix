{
  config,
  pkgs,
  options,
  modulesPath,
  lib,
  utillinuxMinimal,
  specialArgs,
}: {
  # , nix-flake }: {
  # https://github.com/NixOS/nix/issues/4367 I used the workaround proposed in the issue's description
  nix = {
    package = pkgs.nixFlakes; # nix-flake.packages.x86_64-linux.nix-static;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
