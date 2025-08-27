{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.ryax;
in {
  options = {
    ryax = {
      enable = lib.mkOption {
        default = false;
        description = ''
          Whether to enable ryax module.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      kubectl
      kubernetes-helm
      scaleway-cli
    ];

    programs.zsh = {
      initExtraFirst = lib.mkAfter ''
        source <(kubectl completion zsh)
      '';

      shellAliases = {
        k = "kubectl";
        kr = "kubectl --namespace ryaxns";
        kgp = "kubectl get pods --all-namespaces";
        krp = "kubectl get pods --namespace ryaxns";
      };
    };
  };

}
