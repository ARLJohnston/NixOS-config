{ pkgs, ... }:
let
  emacs = (pkgs.emacsWithPackagesFromUsePackage {
    package = pkgs.emacs-pgtk;
    config = "~/.emacs";
    alwaysEnsure = true;

    #extraEmacsPackages = epkgs: [
    #	epkgs.use-package
    #	epkgs.org
    #	epkgs.magit
    #	epkgs.go-mode
    #	epkgs.lsp-mode
    #	epkgs.yasnippet
    #];

    override = final: prev: {
      NIX_CFLAGS_COMPILE = [ "-O3" "-march=native" ];
    };
  });
in
{
  home.packages = with pkgs; [
    #mu4e
    mu
    #lsp-servers

    godef
    gopls

    haskell-language-server

    rust-analyzer

    nil

    nodejs-slim #Used for copilot

    #Org-preview
    texliveMedium
  ];

  programs.emacs = {
    enable = true;
    package = emacs;
  };

  services.emacs = {
    enable = true;
    defaultEditor = true;
  };
}
