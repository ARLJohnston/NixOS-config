{ pkgs, config, inputs, nix-colors, ... }:
{
  programs.firefox = {
    enable = true;

    profiles.alistair = {
      userChrome =
          builtins.readFile ./firefox_css/autohide_bookmarks_and_main_toolbars.css
        + builtins.readFile ./firefox_css/urlbar_centered_text.css
        + ''

        #TabsToolbar {
		        visibility: collapse;
		          display: none
        }

        #alltabs-button{
        		display: none;
        }
      '';

      extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
        consent-o-matic
        decentraleyes
        sponsorblock
        tabliss
        ublock-origin
        youtube-shorts-block
      ];
    };
  };
}
