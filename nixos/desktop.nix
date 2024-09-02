{ pkgs, lib, inputs, ... }:
let
  # arlj-dwl = pkgs.dwl.overrideAttrs (finalAttrs: previousAttrs: {
  #   # NIX_CFLAGS_COMPILE = [ "-O3" "-march=native" ];
  #   conf = builtins.readFile "/home/alistair/config/nixos/config.h";
  # src = pkgs.fetchgit {
  #   url = "https://codeberg.org/dwl/dwl.git";
  #   hash = "sha256-SzySAeWv1wjtMXN3eW9xVuRp6cGFx+XXXh5be/LJ83E=";
  # };

  # patches = [
  #   (pkgs.fetchpatch {
  #     url =
  #       "https://codeberg.org/dwl/dwl-patches/raw/branch/main/patches/bar/bar-0.7.patch";
  #     hash = "sha256-b5DQ4lyBYTlZsjbpbVw8ZXzhBRuEgnDjHyPGW5Cy80M=";
  #   })
  # ];
  # });
in {
  environment.systemPackages = with pkgs; [
    brightnessctl
    wl-clipboard
    dmenu
    dwl
    wmenu
  ];

  security.polkit.enable = true;

  # services.xserver = {
  #   enable = true;
  # displayManager = {
  #   lightdm.enable = true;
  #   startx.enable = true;
  # };

  # windowManager = { exwm.enable = true; };

  # xkb = {
  #   layout = "gb";
  #   options = "ctrl:nocaps";
  # };
  # };

  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${pkgs.dwl}/bin/dwl";
        user = "alistair";
      };
      default_session = initial_session;
    };
  };

  nixpkgs.overlays = [
    (self: super: {
      dwl = super.dwl.overrideAttrs (oldAttrs: rec {
        # patches = [
        #   ./path/to/my-dwm-patch.patch
        # ];
        configFile = super.writeText "config.h" (builtins.readFile ./config.h);
        postPatch = oldAttrs.postPatch or "" + ''

          echo 'Using own config file...'
           cp ${configFile} config.def.h'';
      });
    })
  ];

  # services.displayManager.defaultSession = "none+exwm";
}
