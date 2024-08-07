{ pkgs, inputs, config, ... }:
let
  my_emacs = (pkgs.emacsWithPackagesFromUsePackage {
    package = pkgs.emacs;
    config = ./init.el;
    # defaultInitFile = true;
    alwaysEnsure = false;

    extraEmacsPackages = epkgs:
      with epkgs; [
        all-the-icons
        all-the-icons-completion
        all-the-icons-dired
        evil
        imenu-list
        jinx
        ligature
        envrc
        kind-icon
        org
        org-alert
        org-auto-tangle
        pdf-tools
        yasnippet-capf
        treesit-grammars.with-all-grammars
        use-package
        bind-key
        vterm
        yaml-pro
      ];
    override = final: prev: { NIX_CFLAGS_COMPILE = [ "-O3" "-march=native" ]; };
  });
in {
  home.packages = with pkgs; [
    #Org-preview
    texliveMedium
    tree-sitter
    python3
    nuspell

    (aspellWithDicts (dicts: with dicts; [ en en-computers ]))
    my_emacs
    enchant
  ];

  home.file = { ".emacs" = { source = ./init.el; }; };

  services = {
    emacs = {
      enable = true;
      client.enable = true;
      defaultEditor = true;
      socketActivation.enable = true;
    };
  };

  nixpkgs.overlays = [ (import inputs.emacs-overlay) ];
}
