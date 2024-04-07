{ pkgs, ... }:
{
# let
#     # https://github.com/nix-community/emacs-overlay#extra-library-functionality
#     em = (emacsWithPackagesFromUsePackage {
#       config = ~/.emacs;
#       defaultInitFile = true;
#       package = pkgs.emacs-unstable;
#       alwaysTangle = true;

#       extraEmacsPackages = epkgs: [
#         epkgs.lsp-docker
#         nil
#       ];

#       override = final: prev: {
#         NIX_CFLAGS_COMPILE = [ "-Ofast" "-march=native" ];
#       };
#     });
# in
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
    package = pkgs.emacs-nox;
  };

  services.emacs = {
    enable = true;
    package = pkgs.emacs-nox;
    defaultEditor = true;
  };


#   nixpkgs.overlays = [
#   (import (builtins.fetchTarball {
#     url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
#     sha256 = "11x80s4jh06ibk390q8wgvvi614fapiswmbi6z9xy9d21pf7mw33";
#   }))
# ];
}
