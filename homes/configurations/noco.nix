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
    ./../graphical.nix
    ./../base.nix
    ./../modules/ryax
    {
      adfaure.ryax.enable = true;
      my-programs.atuin.enable = true;
    }
  ];
}
