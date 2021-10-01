{ config, lib, pkgs, my-dotfiles, ... }: {

  # Override the home-manager defined configuration of spotifyd.
  # Forcing Install.WantedBy to be empty enables to have the service
  # defined in my system but not starting at boot time.
  # To start the service : systemctl --user start spotifyd.service
  systemd.user.services.spotifyd.Install.WantedBy = lib.mkForce [ ];

  services.spotifyd = {
    enable = true;
    package = pkgs.spotifyd.override {
      withKeyring = true;
      withPulseAudio = true;
      withMpris = true;
    };

    settings = {
      global = rec {
        username = "youngdadou";
        password_cmd = "${pkgs.pass}/bin/pass spotify.com/${username}";
      };
    };
  };
}
