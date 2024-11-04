{ pkgs, lib, ... }: {
  imports = [
    ./test/test.nix # hello
    ./test/msci.nix
    ./hardware/pipewire.nix
    ./hardware/boot.nix
    ./hardware/power-saving.nix
    ./desktop/dwl.nix
  ];
}
