{
  networking.hostName = "lune";
  time.timeZone = "Europe/Paris";

  nixosModules.cachix.enable = true;
  nixosModules.minimal.enable = true;
  nixosModules.flakes.enable = true;

  nixosModules.graphical = {
    enable = true;
    desktopEnvironment = "niri";
  };

  nixosModules.guix.enable = true;
  nixosModules.syncthing.enable = true;
  nixosModules.vm.enable = true;
  nixosModules.adfaure.enable = true;
}
