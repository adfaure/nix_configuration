{ config, lib, pkgs, ... }:

{
  imports =
  [ <nixpkgs/nixos/modules/profiles/qemu-guest.nix> ];

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "sr_mod" "virtio_blk" ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
  { device = "/dev/disk/by-label/root";
      fsType = "ext4";
  };

  swapDevices =
    [ { device = "/var/swapfile"; size = 1024; }
  ];

  boot.loader.grub.devices= ["/dev/vda"];

  nix.maxJobs = lib.mkDefault 1;
}
