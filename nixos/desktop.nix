{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    brightnessctl
    grim
    wl-clipboard
    river
    slurp
    wofi
    swaybg
    swaylock
  ];

  security.polkit.enable = true;

  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

  services.xserver = {
    enable = true;
    xkb.layout = "gb";
    xkb.model = "thinkpad";
  };

  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${pkgs.river}/bin/river";
        user = "alistair";
      };
      default_session = initial_session;
    };
  };
}
