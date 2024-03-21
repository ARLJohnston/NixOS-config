{ pkgs, config, nix-colors, ... }:
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

        foreground = "${config.colorScheme.palette.base05}";
        background = "${config.colorScheme.palette.base00}";

        regular0 = "${config.colorScheme.palette.base03}";
        regular1 = "${config.colorScheme.palette.base08}";
        regular2 = "${config.colorScheme.palette.base0B}";
        regular3 = "${config.colorScheme.palette.base05}";
        regular4 = "${config.colorScheme.palette.base0D}";
        regular5 = "${config.colorScheme.palette.base08}";
        regular6 = "${config.colorScheme.palette.base0C}";
        regular7 = "${config.colorScheme.palette.base06}";

        bright0 = "${config.colorScheme.palette.base0D}";
        bright1 = "${config.colorScheme.palette.base08}";
        bright2 = "${config.colorScheme.palette.base0B}";
        bright3 = "${config.colorScheme.palette.base0A}";
        bright4 = "${config.colorScheme.palette.base09}";
        bright5 = "${config.colorScheme.palette.base0E}";
        bright6 = "${config.colorScheme.palette.base0C}";
        bright7 = "${config.colorScheme.palette.base07}";
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
      sensible
      tmux-fzf
      tmux-colors-solarized
      resurrect
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
      set-option -g default-command bash

        tmux_conf_theme_colour_1="#${config.colorScheme.palette.base00}"
        tmux_conf_theme_colour_2="#${config.colorScheme.palette.base08}"
        tmux_conf_theme_colour_3="#${config.colorScheme.palette.base08}"
        tmux_conf_theme_colour_4="#${config.colorScheme.palette.base0D}"
        tmux_conf_theme_colour_5="#${config.colorScheme.palette.base0B}"
        tmux_conf_theme_colour_6="#${config.colorScheme.palette.base00}"
        tmux_conf_theme_colour_7="#${config.colorScheme.palette.base0F}"
        tmux_conf_theme_colour_8="#${config.colorScheme.palette.base00}"
        tmux_conf_theme_colour_9="#${config.colorScheme.palette.base0B}"
        tmux_conf_theme_colour_10="#${config.colorScheme.palette.base0D}"
        tmux_conf_theme_colour_11="#${config.colorScheme.palette.base0A}"
        tmux_conf_theme_colour_12="#${config.colorScheme.palette.base08}"
        tmux_conf_theme_colour_13="#${config.colorScheme.palette.base0F}"
        tmux_conf_theme_colour_14="#${config.colorScheme.palette.base00}"
        tmux_conf_theme_colour_15="#${config.colorScheme.palette.base00}"
        tmux_conf_theme_colour_16="#${config.colorScheme.palette.base01}"
        tmux_conf_theme_colour_17="#${config.colorScheme.palette.base0F}"

      set -g @colors-solarized 'dark'
#### COLOUR (Solarized 256)

# default statusbar colors
set-option -g status-style fg=colour136,bg=colour235 #yellow and base02

# default window title colors
set-window-option -g window-status-style fg=colour244,bg=default #base0 and default
#set-window-option -g window-status-style dim

# active window title colors
set-window-option -g window-status-current-style fg=colour166,bg=default #orange and default
#set-window-option -g window-status-current-style bright

# pane border
set-option -g pane-border-style fg=colour235 #base02
set-option -g pane-active-border-style fg=colour240 #base01

# message text
set-option -g message-style fg=colour166,bg=colour235 #orange and base02

# pane number display
set-option -g display-panes-active-colour colour33 #blue
set-option -g display-panes-colour colour166 #orange

# clock
set-window-option -g clock-mode-colour colour64 #green

# bell
set-window-option -g window-status-bell-style fg=colour235,bg=colour160 #base02, red
    '';
# May need to run this to get changes to take effect
# > tmux kill-server
# > tmux new -s test
  };

}
