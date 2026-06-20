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
    # Singularity
    programs.singularity.enable = true;
    programs.singularity.enableFakeroot = true;

    virtualisation.vmVariant = {
      virtualisation.memorySize = 4096;
      virtualisation.diskSize = 8192;
      virtualisation.useNixStoreImage = false;
      virtualisation.qemu.options = [
        "-device virtio-vga-gl" # virtio GPU with OpenGL support
        "-display gtk,gl=on" # or sdl,gl=on — enables host OpenGL context
      ];
    };

    # Enable virtualization
    virtualisation = {
      docker.enable = true;
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
