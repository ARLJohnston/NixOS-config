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

  colorScheme = inputs.nix-colors.colorschemes.zenburn;

  home.packages = with pkgs; [
    eww-wayland
    fd
    grim
    lsd
    ollama
    slurp
    swaybg
    swayidle
    wl-clipboard
    wofi
    zoxide
  ];

  home.file = {
  };

  home.sessionVariables = {
    FZF_DEFAULT_COMMAND = "find ~ -mindepth 1 -maxdepth 1";
  };

  programs.home-manager.enable = true;


  programs.swaylock = {
    enable = true;
    settings = {
      font = "MonoLisa Nerd Font";
      image = "~/lock.png";
      scaling = "fill";
    };
  };
}
