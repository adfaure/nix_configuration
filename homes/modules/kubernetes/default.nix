{
  pkgs,
  lib,
  ...
}: let
in {

  programs.zsh = {
    initExtraFirst = lib.mkAfter ''
      source <(kubectl completion zsh)
    '';

    shellAliases = {
      k="kubectl";
      kgp="kubectl get pods --all-namespaces";
      kr="kubectl get pods --namespace ryaxns";
    };
  };

  home.packages = with pkgs; [
      kubectl
      kubernetes-helm
      scaleway-cli
    ];
}
