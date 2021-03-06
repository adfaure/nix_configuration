{ config, pkgs, nodes, lib, kodama, batsite, ... }:
let
  radicaleCollection = "/data/radicale";
  webPort = 80;
  webSslPort = 443;
  radicalePort = 5232;
  htpasswd = config.sops.secrets.radicaleUsers.path;
in {

  imports = [
    # Include the results of the hardware scan.
    ./hardware-kodama.nix
    # Default linux configuration: users, fonts etc
    ../nixos/profiles/common
    # activate the flake
    ../nixos/modules/flakes

  ];

  # Without this extra configuration deploy-rs fails because sudo requires a password.
  security.sudo.wheelNeedsPassword = false;

  services.openssh.enable = true;
  security.acme.acceptTerms = true;
  security.acme.email = "adrien.faure@protonmail.com";

  services.nginx = {
    enable = true;
    appendHttpConfig = ''
      server_names_hash_bucket_size 64;
    '';

    virtualHosts."adrien-faure.fr" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = { root = "${kodama}"; };
      # Add reverse proxy for radicale
      locations."/radicale/" = {
        proxyPass = "http://localhost:${toString radicalePort}/";
        extraConfig = ''
          proxy_set_header     X-Script-Name /radicale;
          proxy_set_header     X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header     X-Remote-User $remote_user;
          auth_basic           "Radicale - Password Required";
          auth_basic_user_file ${htpasswd};
        '';
      };
    };

    virtualHosts."batsim.adrien-faure.fr" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = { root = "${batsite}"; };
    };

  };

  services.radicale = {
    enable = true;
    settings = {
      server = {
        hosts = [ "localhost:${builtins.toString radicalePort}" ];
      };
      storage = {
        system_folder = "${radicaleCollection}";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    dstat
    wget
    git # Needed for radicale backup
    rsync # for backups
  ]; # ++ pkgs_lists.common;

  networking = {
    firewall.allowedTCPPorts = [ webPort webSslPort radicalePort ];
  };
}
