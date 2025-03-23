{ pkgs, lib, ... }: {
  imports = [
    ./test/test.nix
    ./test/msci.nix
    ./hardware/pipewire.nix
    ./hardware/boot.nix
    ./hardware/power-saving.nix
    ./desktop/dwl.nix
    ./editors/git.nix
  ];
}
