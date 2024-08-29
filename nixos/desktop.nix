{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ brightnessctl wl-clipboard ];

  security.polkit.enable = true;

  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;
}
