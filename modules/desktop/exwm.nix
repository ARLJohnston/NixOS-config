{ pkgs, lib, config, ... }: {
{
  options = {
    exwm.enable =
      lib.mkEnableOption "Enable EXWM";
  };

  config = lib.mkIf config.exwm.enable {
    environment.systemPackages = with pkgs; [
      brightnessctl
      ];

   services.xserver = {
        enable = true;
        displayManager = {
	  gdm.enable = true;
       };
   windowManager.exwm.enable = true;
  };
  };
}
