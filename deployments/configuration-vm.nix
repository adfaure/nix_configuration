let
  nixpkgs-stable = (fetchTarball "https://github.com/NixOS/nixpkgs/archive/18.03.tar.gz");

  my = import ../pkgs/default.nix {};

  pkgs = import <nixpkgs> {};

  pkgs_lists = import ../config/my_pkgs_list.nix { inherit pkgs; };
  users = import ../config/my_users.nix { inherit pkgs; };

  radicaleCollection = "/data/radicale";

  webPort = 80;
  webSslPort = 443;
  radicalePort = 5232;

  inherit (pkgs.lib) concatStrings flip mapAttrsToList;

  users_list = users;
  htpasswd = pkgs.writeText "radicale.users" (concatStrings
    (flip mapAttrsToList users_list (name: user:
      name + ":" + user.hashedPassword + "\n"
    ))
  );

in rec
{
  network.description = "Adrien Faure Personal Network";

  vps =
  { config, pkgs, nodes, lib, ... }:
  rec {

    nixpkgs.config.allowUnfree = true;
    require = [ ../modules/common.nix ];
    imports = [ ../modules/common.nix ];

    system.stateVersion = "18.03";
    # Enable the OpenSSH daemon.
    services.openssh.enable = true;
    services.openssh.permitRootLogin = "yes";

    environment.adfaure.common = {
      enable = true;
    };




    #*************#
    #    Nginx    #
    #*************#
    services.nginx = {
      enable = true;

      appendHttpConfig = ''
        server_names_hash_bucket_size 64;
      '';

      virtualHosts."_" =
      {
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

    #*************#
    # Admin tools #
    #*************#
    environment.systemPackages = with pkgs; [
      dstat
      wget
      git # Needed for radicale backup
      rsync # for backups
    ] ++ pkgs_lists.common;

    #*************#
    #   Network   #
    #*************#
    networking = {
      firewall.allowedTCPPorts = [ webPort webSslPort radicalePort ];
    };

  };
}
