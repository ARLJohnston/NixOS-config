{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    (aspellWithDicts (dicts: with dicts; [ en en-computers ]))

    hyphen
    hunspell
  ];

  environment.pathsToLink = [ "/share/hunspell" "/share/myspell" ];
  environment.variables.DICPATH =
    "/run/current-system/sw/share/hunspell:/run/current-system/sw/share/hyphen";
}
