{
  config,
  lib,
  pkgs,
  my-dotfiles,
  ...
}:
# This emacs package comes from the emcas-overlay
# wich enable to pull dependencies from the emacs configuration
# Keep in mind that this wont install the config file to your home.
pkgs.emacsWithPackagesFromUsePackage {
  config = builtins.readFile "${my-dotfiles}/files/emacs_conf";
  alwaysEnsure = true;
  alwaysTangle = true;
  extraEmacsPackages = epkgs:
    with epkgs; [
      use-package
      monokai-theme
      diminish
      bind-key
      rainbow-delimiters
      smartparens
      # Evil
      evil-surround
      evil-indent-textobject
      evil-cleverparens
      avy
      undo-tree
      helm
      # Git
      magit
      # LaTeX
      # auctex
      helm-bibtex
      cdlatex
      markdown-mode
      flycheck
      smooth-scrolling
      #pkgs.ledger
      #yaml-mode
      #company
      # Haskell
      haskell-mode
      flycheck-haskell
      # Org
      org
      org-ref
      # mail
      # Nix
      pkgs.nix
      nix-buffer
      spaceline # modeline beautification
      winum
      # Maxima
      pkgs.maxima
      langtool
      babel
      # ess -> causes error
      htmlize
      # penwith
      # From spacemacs
      # better-default
      company
      ivy
      git
    ];
  # Optionally override derivations.
  override = epkgs:
    epkgs
    // {
      weechat =
        epkgs.melpaPackages.weechat.overrideAttrs
        (old: {patches = [./weechat-el.patch];});
    };
}
# in {
#   home.file.".emacs".text = builtins.readFile "${my-dotfiles}/files/emacs_conf";
#   home.packages = [
#     (pkgs.writeShellScriptBin "emacs" ''systemd-run --slice=exp-emacs.slice --user -p "Delegate=yes" ${emacs}/bin/emacs $@'')
#   ];
# }

