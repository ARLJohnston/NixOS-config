{ pkgs, config, ... }:
let
  inherit (config.colorScheme) colors;
in
{
	services.mako = {
	  enable = true;
		backgroundColor = "#{colors.base01}";
		borderColor = "#{colors.base0E}";
		textColor = "#{colors.base04}";
		layer = "overlay";
	};
}
