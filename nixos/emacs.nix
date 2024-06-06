{ pkgs, inputs, config, ... }:
let
  my_emacs = (pkgs.emacsWithPackagesFromUsePackage {
    package = pkgs.emacs-pgtk;
    config = ./init.el;
    defaultInitFile = true;
    alwaysEnsure = false;

    extraEmacsPackages = epkgs:
      with epkgs; [
        all-the-icons
        all-the-icons-completion
        all-the-icons-dired
        avy
        cape
        corfu
        diminish
        doom-themes
        elfeed
        envrc
        evil
        evil-collection
        general
        go-mode
        imenu-list
        jinx
        kind-icon
        ligature
        lsp-mode
        lsp-treemacs
        lsp-ui
        magit
        marginalia
        nix-mode
        org
        org-auto-tangle
        pdf-tools
        rustic
        sideline
        sideline-flymake
        tree-sitter-indent
        undo-tree
        vertico
        vterm
        vterm-toggle
        yasnippet
        zoxide
      ];
    override = final: prev: { NIX_CFLAGS_COMPILE = [ "-O3" "-march=native" ]; };
  });
in {
  home.packages = with pkgs; [
    clang
    emacs-lsp-booster
    maple-mono-NF
    #lsp-servers
    erlang-ls

    godef
    gopls

    haskell-language-server

    rust-analyzer

    nixfmt

    #Org-preview
    texliveMedium
    tree-sitter
    python3 # For extra lsp-mode features
    emacs-all-the-icons-fonts
    my_emacs
    enchant
  ];

  home.file = {
    ".emacs" = { source = ./init.el; };
    ".aspell.conf" = { text = "dict-dir /run/current-system/sw/lib/aspell"; };
    ".emacs.d/exwm/Xmodmap".text = ''
      clear lock
      clear control
      keycode 66 = Control_L
      add control = Control_L
      add Lock = Control_R
    '';
  };

  services = {
    emacs = {
      enable = true;
      client.enable = true;
      defaultEditor = true;
    };
  };

  nixpkgs.overlays = [ (import inputs.emacs-overlay) ];
}
