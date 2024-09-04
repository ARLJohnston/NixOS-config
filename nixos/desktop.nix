{ pkgs, lib, inputs, ... }: {
  environment.systemPackages = with pkgs; [
    brightnessctl
    wl-clipboard
    dmenu
    dwl
    wmenu
  ];

  security.polkit.enable = true;

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
        configFile = super.writeText "config.h"
          (builtins.readFile (pkgs.substituteAll { src = ./config.h; }));
        postPatch = oldAttrs.postPatch or "" + ''

          echo 'Using own config file...'
           cp ${configFile} config.def.h'';
      });
    })
  ];
}
