{...}: {
  networking.hostName = "lune";
  time.timeZone = "Europe/Paris";

  nixosModules.cachix.enable = true;
  nixosModules.minimal.enable = true;
  nixosModules.flakes.enable = true;
  nixosModules.graphical.enable = true;
  nixosModules.guix.enable = true;
  nixosModules.syncthing.enable = true;
  nixosModules.vm.enable = true;
  nixosModules.adfaure.enable = true;

  nixosModules.gnome.enable = false;
  nixosModules.niri.enable = true;
}
