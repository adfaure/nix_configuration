{ nixpkgs, config, lib, pkgs, my-dotfiles, dieHooka, ... }:
let
    myWrapper = pkgs.makeSetupHook { deps = [ pkgs.dieHook ]; substitutions = { shell = pkgs.targetPackages.runtimeShell; }; }
                              ./cgroup-wrapper.sh;

    hello-cgroup = pkgs.writeShellScriptBin "hello" ''systemd-run --slice=exp-hello.slice --scope -p "Delegate=yes" ${pkgs.hello}/bin/hello'';
    atom-cgroup = pkgs.writeShellScriptBin "atom" ''systemd-run --slice=exp-atom.slice --scope -p "Delegate=yes" ${pkgs.atom}/bin/atom $@'';
    pycharm-cgroup = pkgs.writeShellScriptBin "pycharm" ''systemd-run --slice=exp-pycharm.slice --scope -p "Delegate=yes" ${pkgs.jetbrains.pycharm-community}/bin/pycharm-community $@'';
    sublime-cgroup = pkgs.writeShellScriptBin "subl" ''systemd-run --slice=exp-sublime.slice --scope -p "Delegate=yes" ${pkgs.sublime3}/bin/sublime3 $@'';
    firefox-cgroup = pkgs.writeShellScriptBin "firefox" ''systemd-run --slice=exp-firefox.slice --scope -p "Delegate=yes" ${pkgs.firefox}/bin/firefox $@'';
in {

  # programs.neovim = {
  #     package = (pkgs.neovim.overrideAttrs (old: {
  #       buildInputs = [ myWrapper ];
  #       postInstall = ''
  #           wrapProgram $out/bin/nvim
  #       '';
  #   }));
  # };

  imports = [
      ./vscode.nix
      ./emacs.nix
  ];

  programs.zsh = {
    shellAliases = {
      # For the moment vim is the only one I cannot figure how to wrap it
      vim = ''systemd-run --slice=exp-vim.slice --scope -p "Delegate=yes" nvim'';
    };

    sessionVariables = { EDITOR = ''systemd-run --slice=exp-vim.slice --scope -p "Delegate=yes" nvim''; };

    initExtra = lib.mkAfter ''
      if [[ "$TERM_PROGRAM" == "vscode" ]]; then
        echo "running term in vscode, moving shell to another cgroup"
        export TERM_PROGRAM=vscode-cgroup-out
        systemd-run --scope --slice=exp-shell.slice -p 'Delegate=yes' zsh
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
    hello-cgroup
    pycharm-cgroup
    sublime-cgroup
    firefox-cgroup
  ];
}