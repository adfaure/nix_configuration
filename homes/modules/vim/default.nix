{
  config,
  lib,
  pkgs,
  my-dotfiles,
  unstable,
  ...
}: let
  my_vim_plugins = pkgs.callPackage ./my_vim_plugins.nix {inherit unstable;};
in {
  home.packages =
    [
      # (pkgs.callPackage ./my_vim.nix { inherit my-dotfiles; })
      pkgs.ctags
      pkgs.ack
    ]
    ++ my_vim_plugins.dependencies;

  programs.neovim = {
    enable = true;
    catppuccin.enable = true;
    catppuccin.flavour = "latte";
    # viAlias = true;
    # vimAlias = true;
    # withPython3 = true;
    # https://github.com/nix-community/home-manager/issues/1712
    extraConfig = builtins.readFile "${my-dotfiles}/files/vimrc";
    extraLuaConfig = builtins.readFile ./init.lua;
    plugins = my_vim_plugins.plugins;
    # extraPackages = with pkgs;
    #   [ (python3.withPackages (ps: with ps; [ black flake8 jedi ])) rnix-lsp ]
    #   ++ my_vim_plugins.dependencies;
    # extraPython3Packages = (ps: with ps; [ jedi ]);
  };
}
