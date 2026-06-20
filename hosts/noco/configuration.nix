{...}: {
  networking.hostName = "noco";
  time.timeZone = "Europe/Paris";
  system.stateVersion = "24.11"; # Did you read the comment?

  nixosModules.cachix.enable = true;
  nixosModules.minimal.enable = true;
  nixosModules.flakes.enable = true;
  nixosModules.graphical.enable = true;
  nixosModules.guix.enable = true;
  nixosModules.syncthing.enable = true;
  nixosModules.vm.enable = true;
  nixosModules.adfaure.enable = true;

  nixosModules.gnome.enable = true;
  nixosModules.niri.enable = false;
}
