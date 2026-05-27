{lib, ...}: {
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nixosModules.vm;
in {
  options.nixosModules.vm = {
    enable = mkEnableOption "vm";
  };
  config = mkIf cfg.enable {
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
      OVMF # For UEFI support
      virtiofsd # For virtiofs filesystem sharing
    ];

    # Enable dconf (needed for virt-manager settings)
    programs.dconf.enable = true;
  };
}
