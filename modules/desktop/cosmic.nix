{ pkgs, lib, config, ... }: {
  options = {
    cosmic-desktop.enable = lib.mkEnableOption "Enables Cosmic Desktop";
  };

  config = lib.mkIf config.cosmic-desktop.enable {
    environment.systemPackages = with pkgs; [ brightnessctl wl-clipboard ];

    security.polkit.enable = true;

    services.desktopManager.cosmic.enable = true;
    services.displayManager.cosmic-greeter.enable = true;

    nix.settings = {
      substituters = [ "https://cosmic.cachix.org" ];
      trusted-public-keys =
        [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
    };

    environment.variables = { NIXOS_OZONE_WL = "1"; };
  };
}
