{ pkgs, inputs, ... }:
let

  my_emacs = (pkgs.emacsWithPackagesFromUsePackage {
    package = pkgs.emacs-pgtk;
    config = ./init.el;
    defaultInitFile = false;
    alwaysEnsure = true;

    extraEmacsPackages = epkgs: [
      (epkgs.trivialBuild {
          pname = "gleam-mode";
          version = "1.0.0";

          packageRequires = with epkgs; [ tree-sitter tree-sitter-indent ];

          src = pkgs.fetchFromGitHub {
            owner = "gleam-lang";
            repo = "gleam-mode";
            rev = "c3342451a09b1ecccd3e7121033c70d286723c51";
            hash = "sha256-HcumZxDg5KYkq2g1fP0UCqKUVG6BqDQ/meafRdnmG2o=";
          };
        })
    ];

    override = final: prev: { NIX_CFLAGS_COMPILE = [ "-O3" "-march=native" ]; };
  });
in {
  home.packages = with pkgs; [
    mu

    clang
    #lsp-servers
    erlang-ls

    godef
    gopls

    haskell-language-server

    rust-analyzer

    nil
    nixfmt

    #Org-preview
    texliveMedium
    emacs-all-the-icons-fonts
    my_emacs
    (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))
  ];

  home.file = {
    ".emacs" = {
      source = ./init.el;
    };
  };

  # services.emacs = { # Does not work properly
  # enable = true;
  # package = my_emacs;
  # };

  # services.bitlbee = {
  #   enable = true;

  #   plugins = with pkgs; [
  #     bitlbee-discord
  #   ];
  # };

  nixpkgs.overlays = [ (import inputs.emacs-overlay) ];
}
                                                                                                                                   