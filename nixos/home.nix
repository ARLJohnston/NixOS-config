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

  services.lorri.enable = true;

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

  # programs.spicetify =
  #   let spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
  #   in {
  #     enable = true;
  #     enabledExtensions = with spicePkgs.extensions; [
  #       adblock
  #       hidePodcasts
  #       shuffle # shuffle+ (special characters are sanitized out of extension names)
  #     ];
  #     theme = spicePkgs.themes.catppuccin;
  #     colorScheme = "mocha";
  #   };

  home.packages = with pkgs; [
    lsd # better ls
    tree
    zoxide
    pamixer
    brightnessctl
    direnv
  ];

  programs.git = {
    enable = true;
    userName = "ARLJohnston";
    userEmail = "github@arljohnston.com";

    extraConfig = {
      core = { editor = "emacsclient"; };
      init = { defaultBranch = "main"; };
    };
  };

  # home.sessionVariables = {
  #   NIXOS_OZONE_WL = 1;
  #   MOZ_ENABLE_WAYLAND = 1;
  #   XDG_SESSION_TYPE = "wayland";
  #   GDK_BACKEND = "wayland,x11";
  #   QT_QPA_PLATFORM = "wayland";
  # };

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
