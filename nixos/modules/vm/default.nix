{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption;
  cfg = config.adfaure.modules.vm;
in {
  options.adfaure.modules.vm = {
    enable = mkEnableOption "vm";
  };
  config = {
    # Enable virtualization
    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = true;
          swtpm.enable = true; # TPM emulation
        };
      };
      spiceUSBRedirection.enable = true; # USB device passthrough
    };

    # Add current user to necessary groups
    users.users.adfaure.extraGroups = [
      "libvirtd"
      "kvm"
    ];

    # Install necessary packages
    environment.systemPackages = with pkgs; [
      virt-manager
      virt-viewer
      spice
      spice-gtk
      spice-protocol
      win-virtio # For Windows guests
      OVMF # For UEFI support
      virtiofsd # For virtiofs filesystem sharing
    ];

    # Enable dconf (needed for virt-manager settings)
    programs.dconf.enable = true;
  };
}
