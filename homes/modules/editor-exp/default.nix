{ nixpkgs, config, lib, pkgs, my-dotfiles, dieHooka, ... }:
let
    myWrapper = pkgs.makeSetupHook { deps = [ pkgs.dieHook ]; substitutions = { shell = pkgs.targetPackages.runtimeShell; }; }
                              ./cgroup-wrapper.sh;

    wrapCmd = cmd: path: pkgs.writeShellScriptBin "${cmd}" ''systemd-run --slice=exp-${cmd}.slice --scope --user -p "Delegate=yes" ${path} $@'';

    atom-cgroup = wrapCmd "atom" "${pkgs.atom}/bin/atom"; # pkgs.writeShellScriptBin "atom" ''systemd-run --slice=exp-atom.slice --user -p "Delegate=yes" ${pkgs.atom}/bin/atom $@'';
    pycharm-cgroup = wrapCmd "pycharm" "${pkgs.jetbrains.pycharm-community}/bin/pycharm-community"; # pkgs.writeShellScriptBin "pycharm" ''systemd-run --slice=exp-pycharm.slice --user -p "Delegate=yes" ${pkgs.jetbrains.pycharm-community}/bin/pycharm-community $@'';
    sublime-cgroup = wrapCmd "subl" "${pkgs.sublime3}/bin/sublime3"; # pkgs.writeShellScriptBin "subl" ''systemd-run --slice=exp-sublime.slice --user -p "Delegate=yes" ${pkgs.sublime3}/bin/sublime3 $@'';
    firefox-cgroup =  wrapCmd "firefox" "${pkgs.firefox}/bin/firefox"; # pkgs.writeShellScriptBin "firefox" ''systemd-run --slice=exp-firefox.slice --user -p "Delegate=yes" ${pkgs.firefox}/bin/firefox $@'';
    vimAlias = ''systemd-run --slice=exp-vim.slice --scope --user -p "Delegate=yes" nvim'';
in {

  imports = [
      ./vscode.nix
      ./emacs.nix
  ];

  programs.zsh = {
    shellAliases = {
      # For the moment vim is the only one I cannot figure how to wrap it
      vim = vimAlias;
    };

    sessionVariables = { EDITOR = vimAlias; };

    initExtra = lib.mkAfter ''
      if [[ "$TERM_PROGRAM" == "vscode" ]]; then
        echo "running term in vscode, moving shell to another cgroup"
        export TERM_PROGRAM=vscode-cgroup-out
        systemd-run --slice=exp-shell.slice --scope --user -p 'Delegate=yes' zsh
        exit 0
      fi
    '';
  };


  programs.browserpass = {
    enable = true;
    browsers = [ "firefox" ];
  };

  home.packages = with pkgs; [
    atom-cgroup
    pycharm-cgroup
    sublime-cgroup
    firefox-cgroup
  ];
}