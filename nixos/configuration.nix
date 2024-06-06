# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ inputs, lib, pkgs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager

    ./hardware-configuration.nix
    ./audio.nix
    ./desktop.nix
    ./power.nix
    ./boot.nix
  ];

  time.timeZone = "Europe/Dublin";
  console.keyMap = "uk";

  environment.sessionVariables = {
    XKB_DEFAULT_LAYOUT = "gb";
    XKB_DEFAULT_OPTIONS = "ctrl:nocaps";
    LANG = lib.mkForce "en_GB.UTF-8";
  };

  #Lock-screen and hinge
  security.pam.services.swaylock = { };
  services.logind = {
    extraConfig = "HandlePowerKey=suspend";
    lidSwitch = "suspend";
  };
  powerManagement.powerUpCommands =
    "sudo rmmod atkbd; sudo modprobe atkbd reset=1";

  i18n = { defaultLocale = "en_GB.UTF-8"; };

  nix = {
    settings = {
      allowed-users = [ "@wheel" ];
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
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
    curl
    acpi
    home-manager
    pcmanfm
    vlc
    zfs
    zfs-prune-snapshots

    (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))
  ];

  #virtualisation.virtualbox.host.enable = true;
  #virtualisation.virtualbox.guest.enable = true;
  # users.extraGroups.vboxusers.members = [ "alistair" ];
  # virtualisation.virtualbox.host.enableExtensionPack = true;

  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ "discord" "spotify" ];

  users.users.alistair = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "networkmanager" "docker" ];

    packages = with pkgs; [
      whatsapp-for-linux
      discord
      direnv
      feh
      firefox
      gh
      gnumake
      teams-for-linux
      thunderbird
      unzip
      openconnect
      ffmpeg_5-full

      (retroarch.override { cores = with libretro; [ desmume ]; })

      #Programming languages
      erlang_27
      erlfmt
      rebar3
      go
      gleam

      cargo
      rustc
      rustfmt

      ghc
      godot_4
      gparted
    ];
  };

  services.xserver.excludePackages = with pkgs; [ xterm ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  hardware.opengl.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
