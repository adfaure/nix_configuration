({ lib, my-dotfiles, ... }: {
  nixpkgs.overlays = [ emacs-overlay.overlay ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.adfaure = { ... }: {
    nixpkgs.overlays = [ emacs-overlay.overlay ];
    imports = [
      # This module enables to inject my-dotfiles into the home-manager modules.
      # Indeed, `extraSpecialArgs` is not provided for the nixos module yet.
      ({ ... }: { _module.args.my-dotfiles = my-dotfiles; })
      ./homes/adfaure.nix
    ];
  };
})
