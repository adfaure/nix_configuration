({
  lib,
  config,
  modulesPath,
  options,
  my-dotfiles,
  emacs-overlay,
  cgvg,
  ...
}: {
  nixpkgs.overlays = [emacs-overlay.overlay];

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
