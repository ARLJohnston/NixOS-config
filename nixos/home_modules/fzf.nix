{ pkgs, config, ... }:
let
  inherit (config.colorScheme) colors;
in
{
  programs.fzf = {
    enable = true;

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

    tmux.enableShellIntegration = config.programs.tmux.enable;
  };
}
