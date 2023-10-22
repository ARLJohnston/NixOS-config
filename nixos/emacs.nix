{ config, pkgs, ... }:
{
  # Emacs
  services.emacs = {
    enable = true;
    defaultEditor = true;
    package = pkgs.emacs29-pgtk;
  };

  environment.systemPackages = with pkgs; [
    emacsPackages.vterm
    #(pkgs.emacs.override {withGTK3 = false; nativeComp = true;})
    emacsPackages.zenburn-theme
  ];
} 
