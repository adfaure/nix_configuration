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
      vcluster
      skopeo
      opentofu
    ];

    programs.zsh = {
      initExtraFirst = lib.mkAfter ''
        source <(kubectl completion zsh)
      '';

      shellAliases = {
        k = "kubectl";
        kn = "kubectl --namespace";
        kngp = "kubectl get pods --namespace";
        knl = "kubectl logs --namespace";
        kr = "kubectl --namespace ryaxns";
        krg = "kubectl --namespace ryaxns get";
        krgp = "kubectl --namespace ryaxns get pods";
        krl = "kubectl --namespace ryaxns logs";
        kre = "kubectl --namespace ryaxns exec -ti";
      };
    };
  };
}
