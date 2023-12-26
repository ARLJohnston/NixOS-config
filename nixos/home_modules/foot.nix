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

        bright0 = "${colors.base0D}"; 
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

  programs.tmux = {
    enable = true;
    prefix = "C-w";
    baseIndex = 1;
    terminal = "screen-256color";
    keyMode = "vi";
    historyLimit = 5000;
    escapeTime = 1;
    clock24 = true;

    plugins = with pkgs.tmuxPlugins; [
      nord
      sensible
      tmux-fzf
    ];

    extraConfig = ''
      bind v split-window -h
      bind s split-window -v
      bind w select-pane -t :.+
      bind W select-pane -t :.-
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      bind q kill-pane

      set-option -g set-titles on
    '';
# May need to run this to get changes to take effect
# > tmux kill-server
# > tmux new -s test
  };

}
