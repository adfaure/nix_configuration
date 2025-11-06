nixos:
    nixos-rebuild switch --flake .#$(hostname)--use-remote-sudo

hm:
    home-manager --flake .#$(hostname) switch -b backup

update-nixvim:
    nix flake update nixvim-config
