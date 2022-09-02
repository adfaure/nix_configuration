{
  config,
  lib,
  pkgs,
  my-dotfiles,
  ...
}: let
  my_vim_plugins = pkgs.callPackage ./my_vim_plugins.nix {};
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
    # viAlias = true;
    # vimAlias = true;
    # withPython3 = true;
    # https://github.com/nix-community/home-manager/issues/1712
    extraConfig = builtins.readFile "${my-dotfiles}/files/vimrc";
    plugins = my_vim_plugins.plugins;
    # extraPackages = with pkgs;
    #   [ (python3.withPackages (ps: with ps; [ black flake8 jedi ])) rnix-lsp ]
    #   ++ my_vim_plugins.dependencies;
    # extraPython3Packages = (ps: with ps; [ jedi ]);

   coc.enable = true;
      # bug: neovim: rebuilding with coc support does not work when nodejs is in PATH
      # https://github.com/nix-community/home-manager/issues/2966
      # Solution:
      # https://github.com/sumnerevans/home-manager-config/commit/da138d4ff3d04cddb37b0ba23f61edfb5bf7b85e
      coc.package = pkgs.vimUtils.buildVimPluginFrom2Nix {
        pname = "coc.nvim";
        version = "2022-05-21";
        src = pkgs.fetchFromGitHub {
          owner = "neoclide";
          repo = "coc.nvim";
          rev = "791c9f673b882768486450e73d8bda10e391401d";
          sha256 = "sha256-MobgwhFQ1Ld7pFknsurSFAsN5v+vGbEFojTAYD/kI9c=";
        };
        meta.homepage = "https://github.com/neoclide/coc.nvim/";
      };
      coc.settings = builtins.fromJSON (builtins.readFile ./coc-settings.json);
   };

  }


