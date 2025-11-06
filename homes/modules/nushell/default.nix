{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my-programs.nushell;
in {
  options = {
    my-programs.nushell = {
      enable = lib.mkOption {
        default = false;
        description = ''
          Whether to enable nushell module.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nushell = {
      enable = true;
      shellAliases = {
        r = "joshuto";
        t1 = "tree -L 1";
        t2 = "tree -L 2";
        t3 = "tree -L 3";

        v = "vim";
        vim = "nvim";
        t = "task";
        b = "bat";
        ns = "nix-shell";
        cat = ''bat --paging=never --style="plain"'';
        # vim = ''nvim'';
        j = "jump";
        # So remote shells are not completly lost because they don't know kitty
        ssh = "TERM=xterm-color ssh";
      };

      environmentVariables = {
        EDITOR = "nvim";
        SSH_ASK_PATH = "";
      };
    };
  };
}
