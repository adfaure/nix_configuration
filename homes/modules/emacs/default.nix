{
  config,
  lib,
  pkgs,
  my-dotfiles,
  wrapCmd,
  ...
}:
let
  cfg = config.my-programs.emacs;
in {
    options = {
    my-programs.emacs = {
      enable = lib.mkOption {
        default = false;
        description = ''
          Whether to enable emacs module.
        '';
      };
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.myEmacs
      (pkgs.aspellWithDicts (d: [d.fr d.en]))
    ];
    home.file.".aspell.conf".text = "data-dir ${pkgs.aspell}/lib/aspell";
    home.file.".emacs".text = builtins.readFile "${my-dotfiles}/files/emacs_conf";
  };
}
