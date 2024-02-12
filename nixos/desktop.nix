{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    brightnessctl
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects

    (where-is-my-sddm-theme.override {
      themeConfig.General = {
        background = "/home/alistair/grub.png";
        backgroundFill = "#434C5E";
        backgroundMode = "none";
        cursorColor = "#88C0D0";
        passwordFontSize = 85;
      };
    })
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
      sddm = {
        enable = true;
        wayland.enable = true;
        theme = "where_is_my_sddm_theme";
      };
      sessionPackages = [ pkgs.sway ];
    };
  };
}
