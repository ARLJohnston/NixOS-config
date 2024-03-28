{pkgs, ...}:
# let
#     # https://github.com/nix-community/emacs-overlay#extra-library-functionality
#     em = (emacsWithPackagesFromUsePackage {
#       config = /home/alistair/.emacs;
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
{
  environment.systemPackages = with pkgs; [
    #lsp-servers

    godef
    gopls

    haskell-language-server

    rust-analyzer

    nodejs-slim #Used for copilot
  ];

  services.emacs = {
    package = pkgs.emacs-unstable;
    enable = true;
  };
  environment.variables.EDITOR = "emacsclient  -a=emacs";

  nixpkgs.overlays = [
  (import (builtins.fetchTarball {
    url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    sha256 = "11x80s4jh06ibk390q8wgvvi614fapiswmbi6z9xy9d21pf7mw33";
  }))
];
}
