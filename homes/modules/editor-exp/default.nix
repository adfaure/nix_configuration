{ nixpkgs, config, lib, pkgs, my-dotfiles, dieHooka, ... }:
let
    myWrapper = pkgs.makeSetupHook { deps = [ pkgs.dieHook ]; substitutions = { shell = pkgs.targetPackages.runtimeShell; }; }
                              ./cgroup-wrapper.sh;

    wrapCmd = cmd: path: pkgs.writeShellScriptBin "${cmd}" ''systemd-run --slice=exp-${cmd}.slice --scope --user -p "Delegate=yes" ${path} $@ '';

    atom-cgroup = wrapCmd "atom" "${pkgs.atom}/bin/atom";
    pycharm-cgroup = wrapCmd "pycharm" "${pkgs.jetbrains.pycharm-community}/bin/pycharm-community";
    sublime-cgroup = wrapCmd "subl" "${pkgs.sublime3}/bin/sublime3";
    firefox-cgroup =  wrapCmd "firefox" "${pkgs.firefox}/bin/firefox";
    vimAlias = ''systemd-run --slice=exp-vim.slice --scope --user -p "Delegate=yes" nvim'';
    vscode-cgroup =  wrapCmd "code" "${pkgs.myVscode}/bin/code";
    emacs-cgroup =  wrapCmd "emacs" "${pkgs.myEmacs}/bin/emacs";

in {

  imports = [
      # ./vscode.nix
      ./../emacs
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
    # firefox
    atom-cgroup
    pycharm-cgroup
    sublime-cgroup
    firefox-cgroup
    vscode-cgroup
    emacs-cgroup
  ];
}