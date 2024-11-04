{ config, pkgs, inputs, lib, ... }:
let
  spicetify-nix = inputs.spicetify-nix;
  spicePkgs = spicetify-nix.packages.${pkgs.system}.default;
in {
  colorScheme = {
    #Taken from https://github.com/minikN/base16-MonokaiPro-scheme-source/blob/master/MonokaiPro-ristretto.yaml
    slug = "Monokai-Pro-(Ristretto)";
    name = "Monokai Pro (Ristretto)";
    author = "Wimer Hazenberg (https://www.monokai.nl)";
    palette = {
      base00 = "2c2525";
      base01 = "564e4e";
      base02 = "807777";
      base03 = "ab9fa1";
      base04 = "d5c8ca";
      base05 = "fff1f3";
      base06 = "fff8f9";
      base07 = "ffffff";
      base08 = "fd6883";
      base09 = "191515";
      base0A = "f9cc6c";
      base0B = "adda78";
      base0C = "85dacc";
      base0D = "a8a9eb";
      base0E = "f38d70";
      base0F = "211c1c";
    };
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ "spotify" ];

  home.username = "alistair";
  home.homeDirectory = "/home/alistair";

  home.stateVersion = "22.11";

  imports = [
    inputs.nix-colors.homeManagerModules.default
    inputs.spicetify-nix.homeManagerModules.default

    ./home_modules/foot.nix
    ./home_modules/fzf.nix
    ./home_modules/starship.nix
    ./home_modules/wofi.nix
    ./home_modules/mako.nix
    ./emacs.nix
    ./home_modules/librewolf.nix
  ];

  home.packages = with pkgs; [
    brightnessctl
    lsd # better ls
    pamixer
    tree
    zoxide
  ];

  programs.git = {
    enable = true;
    userName = "ARLJohnston";
    userEmail = "github@arljohnston.com";

    extraConfig = {
      core = { editor = "emacsclient -c"; };
      init = { defaultBranch = "main"; };
    };
  };

  services.swayidle = { enable = true; };

  home.file = {
    ".config/cosmic/com.system76.CosmicComp/v1/xkb_config".text = ''
      (
      rules: "ctrl:nocaps",
      model: "pc104",
      layout: "us",
      variant: "",
      options: Some("terminate:ctrl_alt_bksp"),
      repeat_delay: 600,
      repeat_rate: 25,
      )
    '';

  };

  programs.home-manager.enable = true;
}
