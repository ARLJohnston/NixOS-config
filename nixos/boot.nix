{ inputs, lib, pkgs, ... }: {
  boot = {
    plymouth = {
      enable = true;
      theme = "breeze";
    };

    consoleLogLevel = 0;
    initrd.verbose = false;

    kernelParams = [
      "quiet"
      "splash"
      "psmouse.synaptics_intertouch=0"
      "i915.i915_enable_rc6=1"
      "pcie_aspm=force"
      "epb=7"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    loader.timeout = 0;
  };

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    zfsSupport = true;
    efiInstallAsRemovable = true;
    device = "/dev/sda";
    splashImage = "/home/alistair/grub.png";
    extraConfig = ''
      acpi_backlight=vendor
      acpi_osi=Linux
    '';
  };

  boot.extraModprobeConfig = ''
    options thinkpad_acpi  fan_control=1
  '';
}
