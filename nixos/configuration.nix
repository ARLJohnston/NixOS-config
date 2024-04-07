# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ inputs, config, lib, pkgs, callPackage, env, ... }:
{
  imports =
    [
      inputs.home-manager.nixosModules.home-manager

      ./hardware-configuration.nix
      ./audio.nix
      ./desktop.nix
      ./power.nix
    ];

  #sops.defaultSopsFile = ./secrets/secrets.yaml;
  #sops.defaultSopsFormat = "yaml";
  #sops.age.keyFile = "/home/alistair/.config/sops/age/keys.txt";

  #sops.secrets.example-key = { };
  #sops.secrets."myservice/my_subdir/my_secret" = { };

  time.timeZone = "Europe/Dublin";
  console.keyMap = "uk";

  environment.sessionVariables = {
    XKB_DEFAULT_LAYOUT = "gb";
    XKB_DEFAULT_OPTIONS = "ctrl:nocaps";
    LANG = lib.mkForce "en_GB.UTF-8";
  };

  #Lock-screen and hinge
  security.pam.services.swaylock = {};
  services.logind = {
    extraConfig = "HandlePowerKey=suspend";
    lidSwitch = "suspend";
  };
  powerManagement.powerUpCommands = "sudo rmmod atkbd; sudo modprobe atkbd reset=1";

  i18n = {
    defaultLocale = "en_GB.UTF-8";
  };

  nix = {
    settings = {
      allowed-users = [ "@wheel" ];
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "/dev/sda";
    splashImage = "/home/alistair/grub.png";
    extraConfig = ''
      quiet
      splash
      acpi_backlight=vendor
      acpi_osi=Linux
    '';
  };
  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelParams = [ "psmouse.synaptics_intertouch=0" ];

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
    curl
    acpi
    git
    home-manager
    networkmanagerapplet
    vlc
    zfs
  ];

  #virtualisation.virtualbox.host.enable = true;
  #virtualisation.virtualbox.guest.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "discord"
      "spotify"
    ];
   users.extraGroups.vboxusers.members = [ "alistair" ];

   virtualisation.virtualbox.host.enableExtensionPack = true;

  users.users.alistair = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "networkmanager"
      "docker"
    ];

    packages = with pkgs; [
      betterdiscordctl
      whatsapp-for-linux
      discord
      feh
      firefox
      gh
      gnumake
      teams-for-linux
      thunderbird
      unzip
      openconnect
      ffmpeg_5-full
      ghostscript

      #Programming languages
      go

      cargo
      rustc
      rustfmt

      ghc
    ];
  };

  services.xserver.excludePackages = with pkgs; [
    xterm
  ];

  hardware.opengl.enable = true;

  nixpkgs.overlays = [ (import inputs.emacs-overlay) ];

#  nixpkgs.overlays = [
#    (import (builtins.fetchTarball {
#      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
#      sha256 = "11x80s4jh06ibk390q8wgvvi614fapiswmbi6z9xy9d21pf7mw33";
#    }))
#  ];
  services.emacs = {
    enable = true;
    defaultEditor = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
