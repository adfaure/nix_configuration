{lib, ...}: {config, ...}: let
  cfg = config.nixosModules.minimal;
  inherit (lib) mkIf mkEnableOption;
in {
  options.nixosModules.minimal = {
    enable = mkEnableOption "minimal";
  };

  config =
    mkIf cfg.enable {
      time.timeZone = "Europe/Paris";
      nixpkgs.config.allowUnfree = true;
      services.printing.enable = true;
      services.blueman.enable = true;
      networking.networkmanager.enable = true;

      # Select internationalisation properties.
      i18n.defaultLocale = "en_US.UTF-8";

      i18n.extraLocaleSettings = {
        LC_ADDRESS = "fr_FR.UTF-8";
        LC_IDENTIFICATION = "fr_FR.UTF-8";
        LC_MEASUREMENT = "fr_FR.UTF-8";
        LC_MONETARY = "fr_FR.UTF-8";
        LC_NAME = "fr_FR.UTF-8";
        LC_NUMERIC = "fr_FR.UTF-8";
        LC_PAPER = "fr_FR.UTF-8";
        LC_TELEPHONE = "fr_FR.UTF-8";
        LC_TIME = "fr_FR.UTF-8";
      };
    };
}
