{ config, pkgs, nodes, lib, ... }:
let
  # This deployement file works only with nixops 1.6.1
  # available from the nix channel: nixos18 https://nixos.org/channels/nixos-18.09

  # my = import ../pkgs/default.nix { };
  radicaleCollection = "/data/radicale";
  webPort = 80;
  webSslPort = 443;
  radicalePort = 5232;
  htpasswd = pkgs.writeText "radicale.users" ''
    adfaure:$6$1povfYo8YR1SMM$lzpE2aBCGZyNFCE7Nr2pizFyLb4O7jB6IJdvuoGHVziBg2ynRjtz/8hemZPFiYX.9AGbyDoXMGoH6.P6SvQPx/
  '';
in {
  # network.description = "Adrien Faure Personal Network";

  nixpkgs.config.allowUnfree = true;

  imports = [
    # Include the results of the hardware scan.
    ./hardware-vultr2.nix
    # Module for my programs
    ../modules/programs/vim
    ../modules/programs/ranger
    ../modules/programs/zsh
    # Default linux configuration: users, fonts etc
    ../modules/profiles/common
  ];

  services.openssh.enable = true;
  # services.openssh.permitRootLogin = "yes";
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
      # locations."/" = { root = "${my.kodama}"; };
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

  services.radicale = {
    enable = true;
    extraArgs = [ ];
    config = let
    in ''
      [server]
      hosts = localhost:${builtins.toString radicalePort}

      [storage]
      filesystem_folder = ${radicaleCollection}
    '';
  };
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
}
