{ pkgs, config, ... }:
let
  inherit (config.colorScheme) colors;
  cfg = config.wayland.windowManager.sway.config;

  left = "h";
  down = "j";
  up = "k";
  right = "l";
in
{
  home.packages = with pkgs; [
    grim
    slurp
    swaybg
    swayidle
    wofi
    wl-clipboard
  ];

  wayland.windowManager.sway = {
    enable = true;
    extraConfig = ''
      workspace number 1
      seat * hide_cursor when-typing enable
    '';
    swaynag = {
      enable = true;
    };
    config = {
      modifier = "Mod4";
      terminal = "footclient";
      output = {
        eDP-1 = {
	        bg = "~/wallpaper.png fill";
        };
      };
      bars = [{
        statusCommand = "i3status-rs $HOME/.config/i3status-rust/config-bottom.toml";
        mode = "hide";
        extraConfig = "height 16";

        #Appearance
        fonts = [ "MonoLisa Nerd Font 10" ];
        colors = {
          background = "#${colors.base00}";
          statusline = "#${colors.base05}";
          focusedWorkspace = { background = "#${colors.base0F}"; border = "#${colors.base07}"; text = "#${colors.base00}"; };
          inactiveWorkspace = { background = "#${colors.base00}"; border = "#${colors.base00}"; text = "#${colors.base05}"; };
        };
      }];
      input = {
          "1:1:AT_Translated_Set_2_keyboard" = {
            xkb_layout = "gb";
            xkb_options = "ctrl:nocaps";
          };
        };
      colors = import ./colors.nix {inherit colors;};

      keybindings = {
        "${cfg.modifier}+q" = "kill";
        "${cfg.modifier}+d" = "exec wofi --show drun";
        "${cfg.modifier}+w" = "exec firefox";
        "${cfg.modifier}+Control+L" = "exec swaylock";
        "${cfg.modifier}+Return" = "exec footclient";

        "${cfg.modifier}+e" = "layout toggle split";
        "${cfg.modifier}+s" = "layout tabbed";
        #"${cfg.modifier}+g" = "layout stacking";

        "${cfg.modifier}+x" = "exec ~/.config/rofi/powermenu.sh";
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

        "${cfg.modifier}+Tab" = "workspace next";
        "${cfg.modifier}+Shift+Tab" = "workspace prev";

        "${cfg.modifier}+space" = "floating toggle";
        "${cfg.modifier}+Shift+space" = "move position center";

	      "${cfg.modifier}+f" = "fullscreen";
        "Print" = "exec 'grim -g \"\$(slurp)\" - | wl-copy -t image/png'";

	      # Scratchpad
        "${cfg.modifier}+Shift+minus" = "move scratchpad";
        "${cfg.modifier}+minus" = "scratchpad show";

	      "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
	      "XF86MonBrightnessUp" = "exec brightnessctl set 5%+";

	      "${cfg.modifier}+XF86MonBrightnessDown" = "exec brightnessctl set 1%-";
	      "${cfg.modifier}+XF86MonBrightnessUp" = "exec brightnessctl set 1%+";

	      "XF86AudioRaiseVolume" = "exec 'pamixer --increase 5'";
	      "XF86AudioLowerVolume" = "exec 'pamixer --decrease 5'";
	      "XF86AudioMute" = "exec 'pamixer --toggle-mute'";
      };
    };
  };

  programs.i3status-rust = {
    enable = true;
    bars = {
      bottom = {

        blocks = [
          {
            block = "memory";
            format = " $icon $mem_used_percents ";
            format_alt = " $icon $swap_used_percents ";
          }
          {
            block = "cpu";
            interval = 1;
            format = "$utilization $frequency ";
          }
          {
            block = "sound";
          }
          {
            block = "battery";
            device = "BAT0";
            format = "INT $percentage $time ";
          }
          {
            block = "battery";
            device = "BAT1";
            format = "EXT $percentage $time ";
          }
          {
            block = "net";
            format = " $icon $ssid $signal_strength $ip ↓$speed_down ↑$speed_up ";
            interval = 2;
          }
          {
            block = "time";
            interval = 1;
            format = " $timestamp.datetime(f:'%F %T') ";
          }
        ];
        #settings = {
        #  theme.overrides = {
        #    background = "#${colors.base00}";
        #    statusline = "#${colors.base05}";
        #    
        #  };
        #};
        theme = "nord-dark";
        icons = "none";
      };
    };
  };

  programs.swaylock = {
    package = pkgs.swaylock-effects;
    enable = true;
    settings = {
      font = "MonoLisa Nerd Font";
      image = "~/lock.png";
      scaling = "fill";
      clock = true;
      indicator = true;
      indicator-radius = 65;

      bs-hl-color = "#${colors.base08}";
      key-hl-color = "#${colors.base0C}";

      inside-color = "#${colors.base01}";
      inside-clear-color = "#${colors.base01}";
      inside-ver-color = "#${colors.base01}";
      inside-wrong-color = "#${colors.base01}";

      line-color = "#${colors.base00}";
      line-ver-color = "#${colors.base00}";
      line-clear-color = "#${colors.base00}";
      line-wrong-color = "#${colors.base00}";

      ring-color = "#${colors.base03}";
      ring-clear-color = "#${colors.base0C}";
      ring-ver-color = "#${colors.base0C}";
      ring-wrong-color = "#${colors.base08}";

      separator-color = "00000000";

      text-color = "#${colors.base06}";
      text-clear-color = "#${colors.base05}";
      text-ver-color = "#${colors.base04}";
      text-wrong-color = "#${colors.base08}";
    };
  };

  programs.wofi = {
    enable = true;
    style = ''
      * {
	      font-family: "MonoLisa Nerd Font", monospace;
      }
      
      window {
	      background-color: #${colors.base07};
      }
      
      #input {
	      margin: 5px;
	      border-radius: 0px;
	      border: none;
	      background-color: #${colors.base03};
	      color: white;
      }
      
      #inner-box {
	      background-color: #${colors.base01};
      }
      
      #outer-box {
	      margin: 2px;
	      padding: 10px;
	      background-color: #${colors.base00};
      }
      
      #scroll {
	      margin: 5px;
      }
      
      #text {
	      padding: 4px;
	      color: #${colors.base05};
      }
      
      #entry:nth-child(even){
	      background-color: #${colors.base02};
      }
      
      #entry:selected {
	      background-color: #${colors.base00};
      }
      
      #text:selected {
        color: #${colors.base0B};
	      background: transparent;
      }
    '';

    settings = {
      font = "MonoLisa Nerd Font 10";
      case-sensitive = false;
      #fuzzy-match = true;
      show-icons = true;
      icon-theme = "Papirus";
      icon-size = 16;
    };
  };

  services.mako = {
    enable = true;
    defaultTimeout = 2500;
    font = "MonoLisa Nerd Font 10";
    layer = "overlay";

    backgroundColor = "#${colors.base02}";
    borderColor = "#${colors.base0D}";
    textColor = "#FFFFFF";
    progressColor = "over #${colors.base08}";
  };
}
