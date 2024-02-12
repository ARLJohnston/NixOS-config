{ config, pkgs, inputs, lib, ...}:
let
  spicetify-nix = inputs.spicetify-nix;
  spicePkgs = spicetify-nix.packages.${pkgs.system}.default;
in
{
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
    ./home_modules/sway.nix
   # ./home_modules/dwl.nix

    spicetify-nix.homeManagerModule
      {
         programs.spicetify = {
           enable = true;
           theme = spicePkgs.themes.Blossom;

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

  colorScheme = inputs.nix-colors.colorschemes.nord;

  home.packages = with pkgs; [
    lsd
    tree
    zoxide
    nordzy-cursor-theme
    nordic
  ];

  home.file = {
  };

  home.sessionVariables = {
  };

  home.pointerCursor = {
    name = "Nordzy-cursors";
    #package = pkgs.gnome.adwaita-icon-theme;
    package = pkgs.nordzy-cursor-theme;
    size = 24;
    x11 = {
        enable = true;
        defaultCursor = "Adwaita";
      };
  };

  gtk = {
    enable = true;
    font.name = "MonoLisa Nerd Font 10";
    theme = {
      name = "Nordic";
      package = pkgs.nordic;
    };
  };
  qt = {
    enable = true;
    
    platformTheme = "qtct";
    
    style.name = "kvantum";
  };
  
  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = ''
        [General]
            theme=GraphiteNordDark
              '';
    
    "Kvantum/GraphiteNord".source = "${pkgs.graphite-kde-theme}/share/Kvantum/GraphiteNord";
  };


  programs.home-manager.enable = true;

  dwl = {
    enable = true;
    patches = [
      #./dwl-patches/focusdirection.patch
      #./dwl-patches/attachbottom.patch
      #./dwl-patches/monfig.patch
      #./dwl-patches/point.patch
      #./dwl-patches/restoreTiling.patch
      #./dwl-patches/toggleKbLayout.patch
      #./dwl-patches/cursor_warp.patch
      #./dwl-patches/output-power-management.patch
      #./dwl-patches/autostart.patch
      ./dwl-patches/swallow.patch
    ];
    cmd = {
      terminal = "${pkgs.foot}/bin/foot";
    };
  };

}
