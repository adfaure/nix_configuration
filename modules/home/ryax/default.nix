{lib, ...}: {
  config,
  pkgs,
  osConfig,
  ...
}: let
  cfg = config.homeManagerModules.ryax;
  hasTag = lib.hasTag osConfig.networking.hostName;
in {

  options.homeManagerModules.ryax = {
    enable = lib.mkOption {
      default = hasTag "ryax";
      description = ''
        Whether to enable ryax module.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      kubectl
      kubernetes-helm

      # TODO
      # scaleway-cli
      helmfile
      vcluster
      skopeo
      opentofu
      zoom-us
    ];

    programs.zsh = {
      initContent = lib.mkAfter ''
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
