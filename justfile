nixos configuration:
    nixos-rebuild switch --flake .#{{configuration}}

hm configuration:
    home-manager --flake .#{{configuration}} switch -b backup
