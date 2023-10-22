{ config, pkgs, ...}:
{
  home.username = "alistair";
  home.homeDirectory = "/home/alistair";

  home.stateVersion = "22.11";

  home.packages = with pkgs; [
    wofi
    eww-wayland
    swaybg
    swayidle
    swaylock-effects
  ];

  home.file = {
  };

  home.sessionVariables = {
  };

  programs.home-manager.enable = true;

  wayland.windowManager.sway = 
    let
      cfg = config.wayland.windowManager.sway.config;

      left = "h";
      down = "j";
      up = "k";
      right = "l";
    in
    {
    enable = true;
    config = rec {
      modifier = "Mod4";
      terminal = "foot";
      output = {
        eDP-1 = {
	  bg = "~/wallpaper.png fill";
	};
      };
      keybindings = {
        "${cfg.modifier}+q" = "kill";
        "${cfg.modifier}+d" = "exec wofi --show drun";
        "${cfg.modifier}+Return" = "exec foot";

	# Focusing
          "${cfg.modifier}+${cfg.left}" = "focus left";
          "${cfg.modifier}+${cfg.down}" = "focus down";
          "${cfg.modifier}+${cfg.up}" = "focus up";
          "${cfg.modifier}+${cfg.right}" = "focus right";
          "${cfg.modifier}+Left" = "focus left";
          "${cfg.modifier}+Down" = "focus down";
          "${cfg.modifier}+Up" = "focus up";
          "${cfg.modifier}+Right" = "focus right";

          # Moving
          "${cfg.modifier}+Shift+${cfg.left}" = "move left";
          "${cfg.modifier}+Shift+${cfg.down}" = "move down";
          "${cfg.modifier}+Shift+${cfg.up}" = "move up";
          "${cfg.modifier}+Shift+${cfg.right}" = "move right";
          "${cfg.modifier}+Shift+Left" = "move left";
          "${cfg.modifier}+Shift+Down" = "move down";
          "${cfg.modifier}+Shift+Up" = "move up";
          "${cfg.modifier}+Shift+Right" = "move right";

          # Workspaces
          "${cfg.modifier}+1" = "workspace number 1";
          "${cfg.modifier}+2" = "workspace number 2";
          "${cfg.modifier}+3" = "workspace number 3";
          "${cfg.modifier}+4" = "workspace number 4";
          "${cfg.modifier}+5" = "workspace number 5";
          "${cfg.modifier}+6" = "workspace number 6";
          "${cfg.modifier}+7" = "workspace number 7";
          "${cfg.modifier}+8" = "workspace number 8";
          "${cfg.modifier}+9" = "workspace number 9";
          "${cfg.modifier}+0" = "workspace number 10";

          # Move workspaces
          "${cfg.modifier}+Shift+1" = "move to workspace number 1";
          "${cfg.modifier}+Shift+2" = "move to workspace number 2";
          "${cfg.modifier}+Shift+3" = "move to workspace number 3";
          "${cfg.modifier}+Shift+4" = "move to workspace number 4";
          "${cfg.modifier}+Shift+5" = "move to workspace number 5";
          "${cfg.modifier}+Shift+6" = "move to workspace number 6";
          "${cfg.modifier}+Shift+7" = "move to workspace number 7";
          "${cfg.modifier}+Shift+8" = "move to workspace number 8";
          "${cfg.modifier}+Shift+9" = "move to workspace number 9";
          "${cfg.modifier}+Shift+0" = "move to workspace number 10";

	  "${cfg.modifier}+f" = "fullscreen";

	  # Scratchpad
          "${cfg.modifier}+Shift+minus" = "move scratchpad";
          "${cfg.modifier}+minus" = "scratchpad show";

	  "XF86MonBrightnessDown" = "exec brightnessctl set 2.5%-";
	  "XF86MonBrightnessUp" = "exec brightnessctl set 2.5%+";

	  "XF86AudioRaiseVolume" = "exec 'pactl set-sink-volume @DEFAULT_SINK@ +1%'";
	  "XF86AudioLowerVolume" = "exec 'pactl set-sink-volume @DEFAULT_SINK@ -1%'";
	  "XF86AudioMute" = "exec 'pactl set-sink-mute @DEFAULT_SINK@ toggle'";
      };
    };
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "MonoLisa Nerd Font:size=10";
      };
      mouse = {
        hide-when-typing = "yes";
      };
    };
  };
}
