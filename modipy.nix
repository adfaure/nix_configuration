{ config, pkgs, ... }:

with import ./accounts.nix;

{
  services.mopidy = {
    enable = false;
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

    [youtube]
    enabled = true
    [spotify]
    enabled = true
    username = ${spotify.user}
    password = ${spotify.password}
    client_id = ${spotify.client_id}
    client_secret = ${spotify.client_secret}
    allow_network = true

    [spotify_tunigo]
    enabled = true

    [audio]
    mixer = software
    mixer_volume =
    output = autoaudiosink
    buffer_time =

    [http]                                    
    enabled = true                            
    hostname = 127.0.0.1                      
    port = 6680                               
    static_dir =                              
    zeroconf = Mopidy HTTP server on $hostname
                                              
    [stream]                                  
    enabled = true                            
    protocols =                               
      http                                    
      https                                   
      mms                                     
      rtmp                                    
      rtmps                                   
      rtsp                                    
    metadata_blacklist =                      
    timeout = 5000                            
                                              
    [m3u]                                     
    enabled = true                            
    base_dir = $XDG_MUSIC_DIR                 
    default_encoding = latin-1                
    default_extension = .m3u8                 
    playlists_dir =                           
                                              
    [softwaremixer]                           
    enabled = true                            
                                              
    [file]                                    
    enabled = true                            
    media_dirs =                              
      $XDG_MUSIC_DIR|Music                    
      ~/|Home                                 
    excluded_file_extensions =                
      .jpg                                    
      .jpeg                                   
    show_dotfiles = false                     
    follow_symlinks = false                   
    metadata_timeout = 1000                   
                                              
    [local]                                   
    enabled = true                            
    library = json                            
    media_dir = $XDG_MUSIC_DIR                
    scan_timeout = 1000                       
    scan_flush_threshold = 100                
    scan_follow_symlinks = false              
    excluded_file_extensions =                
      .directory                              
      .html                                   
      .jpeg                                   
      .jpg                                    
      .log                                    
      .nfo                                    
      .png                                    
      .txt                                    

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
