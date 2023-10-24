{ config, pkgs, ... }:
let
  emacs-overlay = pkgs.fetchFromGitHub {
    owner = "nix-community";
    repo = "emacs-overlay";
    rev = "0e0d24a13321cd93af7f2a10a61fe71f6d81448b";
    hash = "sha256-+FaNp+NjDXypHwKJgzi6UX5NZJNMGF7YC+rLXiawG84=;
  }
{
#{
#    "owner": "nix-community",
#    "repo": "emacs-overlay",
#    "rev": "0e0d24a13321cd93af7f2a10a61fe71f6d81448b",
#    "hash": "sha256-+FaNp+NjDXypHwKJgzi6UX5NZJNMGF7YC+rLXiawG84="
#}

  nixpkgs.overlays = [
    (import (builtins.fetchTarball https://github.com/nix-community/emacs-overlay/archive/master.tar.gz))
  ];
  
  environment.systemPackages = [
    pkgs.emacsGcc  # Installs Emacs 28 + native-comp
  ];

  # Emacs
  #services.emacs = {
  #  enable = true;
  #  defaultEditor = true;
  #  #package = pkgs.emacs29-pgtk;
  #  package = with pkgs; (emacsWithPackages (with emacsPackagesNg; [
  #    vterm
  #    zenburn-theme
  #    evil
  #    org
  #    haskell-mode
  #    nix-mode
  #  ]));
  #};
} 
