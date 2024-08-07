{ config, pkgs, inputs, lib, ... }:
let
  spicetify-nix = inputs.spicetify-nix;
  spicePkgs = spicetify-nix.packages.${pkgs.system}.default;
in {
  colorScheme = {
    #Taken from https://github.com/minikN/base16-MonokaiPro-scheme-source/blob/master/MonokaiPro-ristretto.yaml
    slug = "Monokai-Pro-(Ristretto)";
    name = "Monokai Pro (Ristretto)";
    author = "Wimer Hazenberg (https://www.monokai.nl)";
    palette = {
      base00 = "2c2525";
      base01 = "564e4e";
      base02 = "807777";
      base03 = "ab9fa1";
      base04 = "d5c8ca";
      base05 = "fff1f3";
      base06 = "fff8f9";
      base07 = "ffffff";
      base08 = "fd6883";
      base09 = "191515";
      base0A = "f9cc6c";
      base0B = "adda78";
      base0C = "85dacc";
      base0D = "a8a9eb";
      base0E = "f38d70";
      base0F = "211c1c";
    };
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ "spotify" ];

  home.username = "alistair";
  home.homeDirectory = "/home/alistair";

  home.stateVersion = "22.11";

  imports = [
    inputs.nix-colors.homeManagerModules.default
    inputs.spicetify-nix.homeManagerModules.default

    ./home_modules/foot.nix
    ./home_modules/fzf.nix
    ./home_modules/starship.nix
    ./home_modules/wofi.nix
    ./home_modules/mako.nix
    ./emacs.nix
    ./home_modules/librewolf.nix
  ];

  programs.spicetify =
    let spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    in {
      enable = true;
      enabledExtensions = with spicePkgs.extensions; [
        adblock
        hidePodcasts
        shuffle # shuffle+ (special characters are sanitized out of extension names)
      ];
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";
    };

  home.packages = with pkgs; [ lsd tree zoxide pamixer brightnessctl ];

  services.hyprpaper = {
    enable = true;

    settings = {
      ipc = "off";
      splash = false;
      preload = [ "~/wallpaper.png" ];
      wallpaper = [ "eDP-1,~/wallpaper.png" ];
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    # xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    systemd.enable = true;

    plugins = [
      # inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
    ];

    extraConfig = ''
      bind=,Print,exec,grim -t png -g "$(slurp)" ~/Pictures/$(date +%Y-%m-%d_%H-%m-%s).png
    '';

    settings = {
      "$mod" = "SUPER";

      general = {
        gaps_in = 2;
        gaps_out = 2;
      };

      animations = { enabled = false; };

      misc = {
        disable_hyprland_logo = true;
        disable_autoreload = true;
        enable_swallow = true;
      };

      binds = {
        workspace_back_and_forth = true;
        allow_workspace_cycles = true;
      };

      cursor = { hide_on_key_press = true; };

      device = {
        name = "tpps/2-ibm-trackpoint";
        sensitivity = -0.3;
      };

      input = {
        kb_layout = "gb";
        kb_options = "ctrl:nocaps";
      };

      exec-once = [
        "swaylock -i ~/lock.png"
        # "emacs --fg-daemon"
        "[workspace special:magic] keepassxc ~/Passwords.kbdx"
      ];

      binde = [
        "$mod, H, resizeactive, -10 0"
        "$mod, L, resizeactive, 10 0"
        ",XF86AudioRaiseVolume, exec, pamixer -i 5"
        ",XF86AudioLowerVolume, exec, pamixer -d 5"
        ",XF86AudioMute, exec, pamixer --toggle-mute"
        ",XF86MonBrightnessUp, exec, brightnessctl set +5%"
        ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ];

      bindm = [ "$mod, mouse:272, movewindow" "$mod, mouse:273, resizewindow" ];

      bind = [
        "$mod, W, exec, librewolf"
        "$mod, D, exec, wofi --show drun"
        "$mod, X, exec, ~/.config/rofi/powermenu.sh"
        "$mod, Q, killactive"
        "$mod, F, fullscreen, 1"
        "$mod, TAB, workspace, previous"

        "$mod, P, togglespecialworkspace, magic"
        "$mod SHIFT, P, movetoworkspace, special:magic"
        "$mod, Space, togglefloating"

        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"

        "$mod, 1, workspace, 1"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod, 2, workspace, 2"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod, 3, workspace, 3"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod, 4, workspace, 4"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod, 5, workspace, 5"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod, 6, workspace, 6"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod, 7, workspace, 7"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod, 8, workspace, 8"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod, 9, workspace, 9"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod, 0, workspace, 10"
        "$mod SHIFT, 0, movetoworkspace, 10"

      ];
    };
  };

  programs.git = {
    enable = true;
    userName = "ARLJohnston";
    userEmail = "40921666+ARLJohnston@users.noreply.github.com";

    extraConfig = {
      core = { editor = "emacsclient"; };
      init = { defaultBranch = "main"; };
    };
  };

  home.sessionVariables = {
    NIXOS_OZONE_WL = 1;
    MOZ_ENABLE_WAYLAND = 1;
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland";
  };

  programs.home-manager.enable = true;
}
