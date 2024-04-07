{ config, pkgs, inputs, lib, ...}:
let
  spicetify-nix = inputs.spicetify-nix;
  spicePkgs = spicetify-nix.packages.${pkgs.system}.default;
in
{
  colorScheme = inputs.nix-colors.colorSchemes.everforest;

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "spotify"
    ];

  nixpkgs.overlays = [ (import inputs.emacs-overlay) ];

  home.username = "alistair";
  home.homeDirectory = "/home/alistair";

  home.stateVersion = "22.11";

  imports = [
    inputs.nix-colors.homeManagerModules.default

    ./home_modules/foot.nix
    ./home_modules/fzf.nix
    ./home_modules/starship.nix
    ./home_modules/wofi.nix
    ./home_modules/i3status_rust.nix
    ./home_modules/emacs.nix


    spicetify-nix.homeManagerModule
      {
         programs.spicetify = {
           enable = true;
           theme = spicePkgs.themes.Onepunch;
           colorScheme = "gruvbox";

           enabledExtensions = with spicePkgs.extensions; [
             fullAppDisplay
             shuffle
             adblock
             hidePodcasts
             keyboardShortcut
           ];
         };
      }
  ];



  home.packages = with pkgs; [
    lsd
    tree
    zoxide
  ];

  home.file = {
  };

  home.sessionVariables = {
  };

  programs.home-manager.enable = true;
}
