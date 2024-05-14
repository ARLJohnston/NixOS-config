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

  home.username = "alistair";
  home.homeDirectory = "/home/alistair";

  home.stateVersion = "22.11";

  imports = [
    inputs.nix-colors.homeManagerModules.default

    ./home_modules/foot.nix
    ./home_modules/fzf.nix
    ./home_modules/starship.nix
    ./home_modules/wofi.nix
    ./emacs.nix

    spicetify-nix.homeManagerModule
    {
      programs.spicetify = {
        enable = true;
        theme = spicePkgs.themes.text;
        colorScheme = "kanagawa";

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

  programs.mu = {
    enable = true;
  };

  services.mbsync = {
    enable = true;
  };
  # https://miikanissi.com/blog/email-setup-with-mbsync-mu4e/

  # programs = {
  #   direnv  = {
  #     enable = true;
  #     enableBashIntegration = true;
  #     nix-direnv.enable = true;
  #   };
  #   bash.enable = true;
  # };

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
