{
  networking.hostName = "lune";
  time.timeZone = "Europe/Paris";

  nixosModules.cachix.enable = true;
  nixosModules.minimal.enable = true;
  nixosModules.flakes.enable = true;

  nixosModules.graphical = {
    enable = true;
    desktopEnvironment = "gnome";
  };

  nixosModules.guix.enable = true;
  nixosModules.syncthing.enable = false;
  nixosModules.vm.enable = true;
  nixosModules.adfaure.enable = true;
  nixosModules.actual.enable = true;
  nixosModules.nix-ld.enable = true;
}
