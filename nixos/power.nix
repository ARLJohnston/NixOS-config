{ pkgs, ... }:
{
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };

  services.thermald.enable = true;

  services.tlp = {
    enable = true;
    settings = {
      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto";

      START_CHARGE_THRESH_BAT0 = 70;
      STOP_CHARGE_THRESH_BAT0 = 75;
      START_CHARGE_THRESH_BAT1 = 70;
      STOP_CHARGE_THRESH_BAT1 = 75;
      RESTORE_THRESHOLDS_ON_BAT = 1;

      SOUND_POWER_SAVE_ON_BAT = 10;

      USB_AUTOSUSPEND = 1;

      INTEL_GPU_MIN_FREQ_ON_BAT = 200;
      INTEL_GPU_MAX_FREQ_ON_BAT = 550;
      INTEL_GPU_BOOST_FREQ_ON_BAT = 700;

      AHCI_RUNTIME_PM_ON_BAT = "auto";

      DEVICES_TO_DISABLE_ON_STARTUP = "wwan";
    };
  };
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true;
}
