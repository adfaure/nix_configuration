{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.adfaure.ryax;
in {
  options.adfaure.ryax = {
    enable = lib.mkOption {
      default = false;
      description = ''
        Whether to enable ryax module.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      kubectl
      kubernetes-helm
      scaleway-cli
      helmfile
    ];

    programs.zsh = {
      initExtraFirst = lib.mkAfter ''
        source <(kubectl completion zsh)
      '';

      shellAliases = {
        k = "kubectl";
        kr = "kubectl --namespace ryaxns";
        ks = "kubectl --namespace kube-system";
        kgp = "kubectl get pods --all-namespaces";
        krp = "kubectl get pods --namespace ryaxns";
        kre = "kubectl exec --namespace ryaxns -ti";
      };
    };
  };
}
