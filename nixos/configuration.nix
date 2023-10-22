# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ inputs, config, lib, pkgs, ... }:

{
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
      ./hardware-configuration.nix
      ./desktop.nix
      ./audio.nix
      ./emacs.nix
    ];

  nix = {
    gc = {
      automatic = true;
      options = "--max-freed 1G --delete-older-than 10d";
    };
    settings = {
      allowed-users = [ "alistair" ];
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  services.auto-cpufreq.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "powersave";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 75;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 20;

      PLATFORM_PROFILE_ON_BAT = "low-power";
      START_CHARGE_THRESHOLD_BAT0 = 70;
      STOP_CHARGE_THRESHOLD_BAT0 = 70;
      START_CHARGE_THRESHOLD_BAT1 = 70;
      STOP_CHARGE_THRESHOLD_BAT1 = 70;
      RESTORE_THRESHOLDS_ON_BAT = 1;

      DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth wwan";
    };
  };

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "/dev/sda";
  };
  boot.supportedFilesystems = [ "zfs" ];

  services.zfs = {
    autoSnapshot.enable = true;
    autoScrub.enable = true;
  };

  services.openssh.enable = true;
  networking = {
    hostId = "0f6ac2e8";
    networkmanager.enable = true;
  };

  environment.systemPackages = with pkgs; [
    nix-prefetch
    curl
    git
    home-manager
  ];

  users.users.alistair = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" ];
    packages = with pkgs; [
      firefox
      neovim
      zotero
      thunderbird
      gh
    ];
  };

  time.timeZone = "Europe/Dublin";
  console.keyMap = "uk";
  i18n = {
    defaultLocale = "en_GB.UTF-8";
  };
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
