{ pkgs, config, ... }:
{
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
