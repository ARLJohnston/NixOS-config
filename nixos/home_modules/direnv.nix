{ pkgs, lib, config, ... }: {
  programs.direnv = {
    enable = true;

    nix-direnv = { enable = true; };
  };

  services.lorri = {
    enable = true;
    enableNotifications = true;
    package = pkgs.lorri;
  };

  systemd.user.services.lorri.serviceConfig = {
    ProtectSystem = pkgs.lib.mkForce "full";
    ProtectHome = pkgs.lib.mkForce false;
  };

  home = {
    packages = [
      pkgs.lorri # Lorri CLI
      config.programs.direnv.package # Required to use Lorri service
      config.programs.direnv.nix-direnv.package
    ];
  };
}
