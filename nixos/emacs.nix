{ pkgs, inputs, config, ... }:
let
  my-emacs = with pkgs;
    (emacsPackagesFor emacs-pgtk).emacsWithPackages (epkgs:
      with epkgs; [
        vterm
        pdf-tools
        org-alert
        jinx
        treesit-grammars.with-all-grammars
      ]);
  override = final: prev: { NIX_CFLAGS_COMPILE = [ "-O3" "-march=native" ]; };

  python-packages = ps: with ps; [ grpcio-tools ];

in {

  home.packages = with pkgs; [
    texliveFull
    texlivePackages.standalone
    (python3.withPackages python-packages)

    my-emacs
    (hunspellWithDicts [ hunspellDicts.en_GB-ize ])
  ];

  home.file = {
    ".emacs.d/init.el".source = ./init.el;

    ".config/enchant/hunspell/".source =
      "${pkgs.hunspellDicts.en_GB-ize}/share/hunspell/";
  };

  nixpkgs.overlays = [ (import inputs.emacs-overlay) ];
}
