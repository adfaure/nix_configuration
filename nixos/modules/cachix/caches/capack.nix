{
  nix = {
    settings.substituters = [
      "https://capack.cachix.org"
      "https://nixpkgs-review-gha.cachix.org"
    ];
    settings.trusted-public-keys = [
      "capack.cachix.org-1:38D+QFk3JXvMYJuhSaZ+3Nm/Qh+bZJdCrdu4pkIh5BU="
      "nixpkgs-review-gha.cachix.org-1:6R3LPTtyfgo4pJASCKrU3iUUrrxVKjW5+Ot9S5SWeKM="
    ];
  };
}
