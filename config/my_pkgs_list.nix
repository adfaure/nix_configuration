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
    nixops
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
    # Dictionnaries
    aspellDicts.fr
    aspellDicts.en
    # Message and RSS
    #qtox
    #skype
    #tdesktop
    gnome3.polari
    liferea
    rambox

    # Media
    vlc
    # Utils
    gnome3.gnome-disk-utility
    xorg.xkill
    wireshark-gtk
    git-cola
    gitg
    sakura

    # storage
    ntfs3g
    exfat
    parted
    hdparm
    sysstat
    gsmartcontrol
    linuxPackages.perf
    # Password
    gnupg
    rofi-pass

    virtualbox

    # Graphic tools
    gcolor3
    graphviz
    imagemagick
    inkscape
    libreoffice
    sublime3
    rambox
  ];

  development =
  [
    gitAndTools.gitFull
    python3
    python2
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
    neovim
    # Web Site
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
    wesnoth-dev
  ];

}
