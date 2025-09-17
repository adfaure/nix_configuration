nixos configuration:
    nixos-rebuild switch --flake .#{{configuration}} --use-remote-sudo

hm configuration:
    home-manager --flake .#{{configuration}} switch -b backup

update-nixvim:
    nix flake update nixvim-config
