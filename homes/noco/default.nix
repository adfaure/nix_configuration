{
  pkgs,
  home-manager,
  home-module,
  sops-nix,
  catppuccin,
  extraSpecialArgs,
  ...
}:
home-manager.lib.homeManagerConfiguration {
  inherit extraSpecialArgs pkgs;
  modules = [
    home-module
    sops-nix.homeManagerModules.sops
    catppuccin.homeManagerModules.catppuccin
    ./../modules/graphical.nix
    ./../modules/base.nix
    ./../modules/ryax
    {
      adfaure.ryax.enable = true;
      adfaure.home-modules.user-timers.enable = false;
    }
  ];
}
