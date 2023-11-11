{ config, pkgs, inputs, lib, ...}:
{
  home.username = "alistair";
  home.homeDirectory = "/home/alistair";

  home.stateVersion = "22.11";

  imports = [
    inputs.nix-colors.homeManagerModules.default
  ];

  colorScheme = inputs.nix-colors.colorschemes.gruvbox-dark-medium;

  home.packages = with pkgs; [
    wofi
    eww-wayland
    swaybg
    swayidle
    lsd
    zoxide
    fd
    grim
    slurp
    wl-clipboard
    ollama
  ];

  home.file = {
  };

  home.sessionVariables = {
    FZF_DEFAULT_COMMAND = "find ~ -mindepth 1 -maxdepth 1";
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
      #bars = [{
      #  command = "waybar";
      #}];
      input = {
          "1:1:AT_Translated_Set_2_keyboard" = {
            xkb_layout = "gb";
            xkb_options = "ctrl:nocaps";
          };
        };
      # Always execute foot client on startup
      startup = [
        { command = "exec --no-startup-id sway-msg 'workspace:scratchpad; footclient'" ; always = true; }
      ];
      keybindings = {
        "${cfg.modifier}+q" = "kill";
        "${cfg.modifier}+d" = "exec wofi --show drun";
        "${cfg.modifier}+w" = "exec firefox";
        "${cfg.modifier}+Control+L" = "exec swaylock";
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

        "${cfg.modifier}+Tab" = "workspace next";
        "${cfg.modifier}+Shift+Tab" = "workspace prev";

        "${cfg.modifier}+space" = "floating toggle";

	      "${cfg.modifier}+f" = "fullscreen";
        "Print" = "exec 'grim -g \"\$(slurp)\" - | wl-copy -t image/png'";

	# Scratchpad
        "${cfg.modifier}+Shift+minus" = "move scratchpad";
        "${cfg.modifier}+minus" = "scratchpad show";

	      "XF86MonBrightnessDown" = "exec brightnessctl set 1-";
	      "XF86MonBrightnessUp" = "exec brightnessctl set 1+";

	      "XF86AudioRaiseVolume" = "exec 'pamixer --increase 5'";
	      "XF86AudioLowerVolume" = "exec 'pamixer --decrease 5'";
	      "XF86AudioMute" = "exec 'pamixer --toggle-mute'";
      };
    };
  };

  programs.swaylock = {
    enable = true;
    settings = {
      font = "MonoLisa Nerd Font";
      image = "~/lock.png";
      scaling = "fill";
    };
  };

  programs.foot =
    let
      inherit (config.colorScheme) colors;
    in
    {
    enable = true;
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
        regular5 = "${colors.base0F}"; 
        regular6 = "${colors.base0C}"; 
        regular7 = "${colors.base06}"; 

        bright0 = "${colors.base04}"; 
        bright1 = "${colors.base08}"; 
        bright2 = "${colors.base0B}"; 
        bright3 = "${colors.base0A}"; 
        bright4 = "${colors.base0D}"; 
        bright5 = "${colors.base0F}"; 
        bright6 = "${colors.base0C}"; 
        bright7 = "${colors.base07}"; 
      };
    };
  };

	programs.starship = {
		enable = true;
    enableBashIntegration = true;

    settings = {
      character = {
        success_symbol = "λ ➜(bold)";
        error_symbol = "λ ➜(bold)";
      };
      "$schema" = "https://starship.rs/config-schema.json";
    };
	};

  programs.fzf =
    let
      inherit (config.colorScheme) colors;
    in
    {
    enable = true;
    #defaultCommand = "fd ~ -type d -prune -o -type f -print -o -type l -print 2> /dev/null | sed s/^$HOME/,,";

    colors = {
      fg      = "${colors.base04}";
      "fg+"   = "${colors.base06}";
      bg      = "${colors.base00}";
      "bg+"   = "${colors.base01}";
      hl      = "${colors.base0D}";
      "hl+"   = "${colors.base0D}";
      spinner = "${colors.base0C}";
      header  = "${colors.base0D}";
      info    = "${colors.base05}";
      pointer = "${colors.base0C}";
      marker  = "${colors.base0C}";
      prompt  = "${colors.base05}";
    };
  };
}
