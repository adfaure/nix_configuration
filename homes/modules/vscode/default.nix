{ config, lib, pkgs, my-dotfiles, ... }:
let
  extensions = (with pkgs.vscode-extensions; [
    bbenoist.Nix
    ms-python.python
    ms-azuretools.vscode-docker
    ms-vscode-remote.remote-ssh
    vscodevim.vim
  ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
      name = "org-mode";
      publisher = "tootone";
      version = "0.5.0";
      sha256 = "sha256-vXwo3oFLwK/wY7XEph9lGvXYIxjZsxeIE4TVAROmV2o=";
  }];

  vscode-with-extensions =
    pkgs.vscode-with-extensions.override { vscodeExtensions = extensions; };
in {

  home.packages = [ vscode-with-extensions ];
}
