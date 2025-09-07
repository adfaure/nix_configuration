nixos configuration:
    nixos-rebuild switch --flake .#{{configuration}} --use-remote-sudo

hm configuration:
    home-manager --flake .#{{configuration}} switch -b backup
