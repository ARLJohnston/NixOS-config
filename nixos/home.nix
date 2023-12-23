{ config, pkgs, inputs, lib, ...}:
let
  spicetify-nix = inputs.spicetify-nix;
  spicePkgs = spicetify-nix.packages.${pkgs.system}.default;
in
{
  home.username = "alistair";
  home.homeDirectory = "/home/alistair";

  home.stateVersion = "22.11";

  imports = [
    inputs.nix-colors.homeManagerModules.default

    ./home_modules/foot.nix
    ./home_modules/fzf.nix
    ./home_modules/starship.nix
    ./home_modules/sway.nix

    spicetify-nix.homeManagerModule
      {
         programs.spicetify = {
           enable = true;
           theme = spicePkgs.themes.Ziro;
           colorScheme = "Blue Dark";

           enabledExtensions = with spicePkgs.extensions; [
             fullAppDisplay
             shuffle
             adblock
             hidePodcasts
           ];
         };
      }
  ];

  colorScheme = inputs.nix-colors.colorschemes.nord;

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
