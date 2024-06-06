{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    brightnessctl
    grim
    wl-clipboard
    slurp
    wofi
    swaybg
    swaylock
  ];

  # services.xserver.displayManager.lightdm.enable = true;
  # services.xserver.windowManager.exwm.enable = true;

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
        command = "${pkgs.hyprland}/bin/hyprland";
        user = "alistair";
      };
      default_session = initial_session;
    };
  };
}
