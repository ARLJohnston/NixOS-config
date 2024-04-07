{ config, pkgs, inputs, lib, ...}:
let
  spicetify-nix = inputs.spicetify-nix;
  spicePkgs = spicetify-nix.packages.${pkgs.system}.default;
in
{
  colorScheme = {
    slug = "solarized-gruvbox-dark";
    name =  "Solarized Gruvbox Dark";
    author = "https://ethanschoonover.com/solarized/";
    palette = {
      base00 = "002b36";
      base01 = "073642";
      base02 = "586e75";
      base03 = "657b83";
      base04 = "839496";
      base05 = "93a1a1";
      base06 = "eee8d5";
      base07 = "fdf6e3";
      base08 = "859900";
      base09 = "b58900";
      base0A = "dc322f";
      base0B = "cb4b16";
      base0C = "2aa198";
      base0D = "268bd2";
      base0E = "6c71c4";
      base0F = "d33682";
    };
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "spotify"
    ];

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
