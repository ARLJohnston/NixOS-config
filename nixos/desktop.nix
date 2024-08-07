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

  security.polkit.enable = true;

  # services.desktopManager.cosmic.enable = true;
  # services.displayManager.cosmic-greeter.enable = true;
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
