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
    defaultEditor = true;
  };

  nixpkgs.overlays = [
  (import (builtins.fetchTarball {
    url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    sha256 = "0i7z6nwhjzkk1i7r3bxksl4q7wgvhzj0c7aly165xh6l28z62pv7";
  }))
];
}
