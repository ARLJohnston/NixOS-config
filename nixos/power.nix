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
      # CPU_SCALING_GOVERNOR_ON_AC = "performance";
      # CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      # CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      # CPU_ENERGY_PERF_POLICY_ON_BAT = "powersave";
      # PLATFORM_PROFILE_ON_AC="performance";
      # PLATFORM_PROFILE_ON_BAT="low-power";

      # CPU_MIN_PERF_ON_AC = 0;
      # CPU_MAX_PERF_ON_AC = 100;
      # CPU_MIN_PERF_ON_BAT = 0;
      # CPU_MAX_PERF_ON_BAT = 20;

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

      DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth wwan";
    };
  };
}
