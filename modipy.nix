{ config, pkgs, ... }:

with import ./accounts.nix;

{
  services.mopidy = {
    enable = true;
    extensionPackages = with pkgs; [
      mopidy-spotify
      mopidy-moped
      mopidy-mopify
      mopidy-youtube
      mopidy-spotify-tunigo
      mopidy-iris
    ];
    configuration = ''
    [core]
    restore_state = true
    [local]
    enabled = true
    [spotify]
    username = ${spotify.user}
    password = ${spotify.password}
    client_id = ${spotify.client_id}
    client_secret = ${spotify.client_secret}
    allow_network = true
    [audio]
    mixer = software
    mixer_volume =
    output = autoaudiosink
    buffer_time =
    [mpd]
    enabled = true
    hostname = 127.0.0.1
    port = 6600
    password =
    max_connections = 20
    connection_timeout = 60
    zeroconf = Mopidy MPD server on $hostname
    command_blacklist =
       listall
       listallinfo
    default_playlist_scheme = m3u
    '';
  };
}
