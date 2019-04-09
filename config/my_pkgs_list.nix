{ pkgs }:

with pkgs;
let
  my_dotfiles = builtins.fetchTarball "https://github.com/mickours/dotfiles/archive/master.tar.gz";
in
{
  common = [
    # nix_utils
    nix-prefetch-scripts
    nix-zsh-completions
    # monitoring
    psmisc
    pmutils
    nmap
    htop
    usbutils
    iotop
    stress
    tcpdump
    # files
    file
    tree
    ncdu
    unzip
    unrar
    # tools
    pass
    zsh
    tmux
    ranger
    # ranger previews
    libcaca   # video
    highlight # code
    atool     # archives
    w3m       # web
    poppler   # PDF
    mediainfo # audio and video
    # my vim config
    (pkgs.callPackage ./my_vim.nix { })
    (pkgs.callPackage ./my_emacs.nix { })
    # nixops
    qemu
    taskwarrior
    timewarrior
  ];

  graphical = [
    # Gnome stuff
    # For system Monitor plugin
    gobjectIntrospection
    libgtop
    json_glib
    glib_networking
    chrome-gnome-shell
    arandr

    # Web
    firefox
    chromium
    # Dictionnaries
    aspellDicts.fr
    aspellDicts.en
    # Message and RSS
    #qtox
    #tdesktop
    liferea

    # Media
    vlc
    # Utils
    xorg.xkill
    wireshark-gtk
    git-cola
    gitg
    sakura
    evince

    # storage
    ntfs3g
    exfat
    parted
    hdparm
    sysstat
    gsmartcontrol
    linuxPackages.perf
    spotify
    # Password
    gnupg

    virtualbox

    # Graphic tools
    gcolor3
    graphviz
    imagemagick
    inkscape
    sublime3

    rambox
    godot
  ];

  development =
  [
    taskwarrior
    taskserver
    gitAndTools.gitFull
    gcc
    ctags
    gnumake
    wget
    cmake
    gdb
    direnv
    entr
    pandoc
    # Editors
    hugo
    # Misc
    cloc
    jq
    qemu
    # printers
    saneBackends
    samsungUnifiedLinuxDriver
    # fun
    fortune
    sl
    sshfs
  ];

}
