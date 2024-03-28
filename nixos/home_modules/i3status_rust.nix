{ pkgs, config, nix-colors, ... }:
{
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
            format = "INT $percentage $time $status";
          }
          {
            block = "battery";
            device = "BAT1";
            format = "EXT $percentage $time $status";
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
        theme = "gruvbox-dark";
        icons = "none";
      };
    };
  };
}
