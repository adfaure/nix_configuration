# Website deployment with nixops

Nixops is channel-dependant, to update nixos version on deployed machines, set the channel `nixpgks` to the desired nix-channel.
Such as:

```
nix-channel --add https://nixos.org/channels/nixos-20.03 nixpkgs
```

The lack of reproducibility has been issued here: https://github.com/NixOS/nixops/issues/736
