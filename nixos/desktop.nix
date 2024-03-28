{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    brightnessctl
    grim
    i3bar-river
    river
    slurp
    wofi
  ];

  security.polkit.enable = true;

  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

  services.xserver = {
    enable = true;
    xkb.layout = "gb";
    displayManager ={
      gdm = {
        enable = true;
      };
      sessionPackages = [ pkgs.river ];
    };
  };
}
