{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    brightnessctl
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects
  ];

  security.polkit.enable = true;

  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

  services.xserver = {
    enable = true;
    layout = "gb";
    displayManager ={
      sddm = {
        enable = true;
      };
      sessionPackages = [ pkgs.sway ];
    };
  };
}
