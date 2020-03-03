let

  # This deployement file works only with nixops 1.6.1
  # available from the nix channel: nixos18 https://nixos.org/channels/nixos-18.09

  my = import ../pkgs/default.nix {};

  pkgs = import <nixpkgs> {};

  pkgs_lists = import ../config/my_pkgs_list.nix { inherit pkgs; };

  radicaleCollection = "/data/radicale";

  webPort = 80;
  webSslPort = 443;
  radicalePort = 5232;

  modules = import ../modules/module-list.nix;

  inherit (pkgs.lib) concatStrings flip mapAttrsToList;

  # Find a way to get it from defined users
  htpasswd = pkgs.writeText "radicale.users"  ''
    adfaure:$6$1povfYo8YR1SMM$lzpE2aBCGZyNFCE7Nr2pizFyLb4O7jB6IJdvuoGHVziBg2ynRjtz/8hemZPFiYX.9AGbyDoXMGoH6.P6SvQPx/
  '';
in rec
{
  network.description = "Adrien Faure Personal Network";

  vps =
  { config, pkgs, nodes, lib, ... }:
  rec {

    nixpkgs.config.allowUnfree = true;

    imports = [
      ./hardware-vultr.nix
    ];

    require = modules;

    environment.adfaure.headless.enable = true;

    system.stateVersion = "19.03";
    deployment.targetHost = "217.69.0.69";

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;
    # services.openssh.permitRootLogin = "yes";

    #*************#
    #    Nginx    #
    #*************#
    services.nginx = {

      enable = true;

      appendHttpConfig = ''
        server_names_hash_bucket_size 64;
      '';

      virtualHosts."adrien-faure.fr" =
      {
        forceSSL = true;
        enableACME = true;

        locations."/" = {
          root = "${my.kodama}";
        };

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
    };

    #****************#
    #    Radicale    #
    #****************#
    services.radicale = {
      enable = true;
      extraArgs = [];
      config = let
      in ''
        [server]
        hosts = localhost:${builtins.toString radicalePort}

        [auth]
        type = htpasswd
        htpasswd_filename = ${htpasswd}
        htpasswd_encryption = crypt

        [storage]
        filesystem_folder = ${radicaleCollection}
      '';
    };

   # services.cron.enable = true;
   # services.cron.systemCronJobs = let
   #   # Contact and Calendar backups
   #   radicaleBackups = "/data/backups/radicale";

   #   backupScript = pkgs.writeScript "backup.sh" ''
   #     #!/usr/bin/env bash

   #     COLLECTIONS="${radicaleCollection}"
   #     # adapt to where you want to back up information
   #     BACKUP="${radicaleBackups}"
   #     tar zcf "$BACKUP/dump-`date +%V`.tgz" "$COLLECTIONS"
   #   '';

   # in [
   #   "@weekly radicale ${backupScript} > /tmp/log 2>&1"
   # ];

    #*************# grep CRON /var/log/syslog
    # Admin tools #
    #*************#
    environment.systemPackages = with pkgs; [
      dstat
      wget
      git # Needed for radicale backup
      rsync # for backups
    ]; # ++ pkgs_lists.common;

    #*************#
    #   Network   #
    #*************#
    networking = {
      firewall.allowedTCPPorts = [ webPort webSslPort radicalePort ];
    };

  };
}

