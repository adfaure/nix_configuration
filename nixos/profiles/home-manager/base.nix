({
  config,
  my-dotfiles,
  cgvg,
  ...
}: {
  nixpkgs.overlays = [];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.adfaure = {...}: {
    imports = [
      # This module enables to inject my-dotfiles into the home-manager modules.
      # Indeed, `extraSpecialArgs` is not provided for the nixos module yet.
      ({...}: {
        _module.args = {
          my-dotfiles = my-dotfiles;
          cgvg = cgvg;
        };
      })
      ../../../homes/base.nix
    ];
  };
})
