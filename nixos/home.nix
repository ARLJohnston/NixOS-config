{ config, pkgs, inputs, lib, ...}:
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
