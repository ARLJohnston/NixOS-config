{ pkgs, config, ... }:
let
  inherit (config.colorScheme) colors;
in
{
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        font = "MonoLisa Nerd Font:size=10";
      };
      mouse = {
        hide-when-typing = "yes";
      };
      colors = {
        alpha = 0.8;

        foreground = "${colors.base05}"; 
        background = "${colors.base00}"; 

        regular0 = "${colors.base03}"; 
        regular1 = "${colors.base08}"; 
        regular2 = "${colors.base0B}"; 
        regular3 = "${colors.base05}"; 
        regular4 = "${colors.base0D}"; 
        regular5 = "${colors.base08}"; 
        regular6 = "${colors.base0C}"; 
        regular7 = "${colors.base06}"; 

        bright0 = "${colors.base04}"; 
        bright1 = "${colors.base08}"; 
        bright2 = "${colors.base0B}"; 
        bright3 = "${colors.base0A}"; 
        bright4 = "${colors.base09}"; 
        bright5 = "${colors.base0E}"; 
        bright6 = "${colors.base0C}"; 
        bright7 = "${colors.base07}"; 
      };
    };
  };

  #programs.tmux = {
  #  enable = true;
  #  keyMode = "vi";
  #  #shortcut = "w";
  #  prefix = "C-Space";
  #  shortcut = "Space";
  #  terminal = "tmux-256color";
  #  plugins = with pkgs.tmuxPlugins; [
  #    nord
  #    tmux-fzf
  #  ];
  #};
}
