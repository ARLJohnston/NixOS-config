{ pkgs, inputs, ... }:
let
  my-emacs = with pkgs;
    (emacsPackagesFor emacs-pgtk).emacs.pkgs.withPackages (epkgs:
      with epkgs; [
        vterm
        pdf-tools
        org-alert
        jinx
        treesit-grammars.with-all-grammars
      ]);
in {

  home.packages = with pkgs; [
    texliveFull
    texlivePackages.standalone
    nixd

    my-emacs
    python312
    (hunspellWithDicts [ hunspellDicts.en_GB-ise ])
  ];

  home.file = {
    ".emacs.d/init.el".source = ./init.el;

    ".config/enchant/hunspell/".source =
      "${pkgs.hunspellDicts.en_GB-ize}/share/hunspell/";
  };

  nixpkgs.overlays = [ (import inputs.emacs-overlay) ];
}
