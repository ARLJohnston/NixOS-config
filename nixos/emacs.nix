{ pkgs, inputs, config, ... }:
let
  my-emacs = with pkgs;
    (emacsPackagesFor emacs-pgtk).emacsWithPackages
    (epkgs: with epkgs; [ vterm pdf-tools ]);
  override = final: prev: { NIX_CFLAGS_COMPILE = [ "-O3" "-march=native" ]; };

  # my-emacs = (pkgs.emacsWithPackagesFromUsePackage {
  #   package = pkgs.emacs-pgtk;
  #   config = ./init.el;
  #   alwaysEnsure = false;

  #   extraEmacsPackages = epkgs: with epkgs; [ pdf-tools vterm ];
  #   override = final: prev: { NIX_CFLAGS_COMPILE = [ "-O3" "-march=native" ]; };
  # });
in {

  home.packages = with pkgs; [
    texliveMedium
    tree-sitter
    python3

    my-emacs
  ];

  home.file = { ".emacs".source = ./init.el; };

  services = {
    emacs = {
      enable = true;
      defaultEditor = true;
      package = my-emacs;
      socketActivation.enable = true;
    };
  };

  nixpkgs.overlays = [ (import inputs.emacs-overlay) ];
}
