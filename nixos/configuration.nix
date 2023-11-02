# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ inputs, config, lib, pkgs, callPackage, ... }:

{
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
      ./hardware-configuration.nix
      ./desktop.nix
      ./audio.nix
      ./power.nix
    ];

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
    gc = {
      automatic = true;
      options = "--max-freed 1G --delete-older-than 10d";
    };
    settings = {
      allowed-users = [ "alistair" ];
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "/dev/sda";
    splashImage = "/home/alistair/Downloads/lock.png";
    extraConfig = ''
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
    nix-prefetch
    curl
    acpi
    git
    home-manager
    networkmanagerapplet
    docker
    nodejs-slim
    rnix-lsp
  ];

  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      # Add additional package names here
      "discord"
			"spotify"
      "jetbrains.idea-ultimate"
      "idea-ultimate"
    ];

  users.users.alistair = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "networkmanager" "docker" ];
    packages = with pkgs; [
      firefox
      neovim
      zotero
      thunderbird
      teams-for-linux
      discord
      gh
      feh
      act
      spotify
      jetbrains.idea-ultimate
      jetbrains.jdk
    ];
  };

  services.emacs.package = pkgs.emacs-unstable;
  services.emacs.enable = true;

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
      sha256 = "12dy44h67mps72mgznvcd0w245hd4hbscxqgcm3vbvd766w9cvgl";
    }))
  ];
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
