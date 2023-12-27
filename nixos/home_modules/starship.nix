{ pkgs, config, ... }:
{
	programs.starship = {
		enable = true;
    enableBashIntegration = true;

    settings = {
      #character = {
      #  success_symbol = "λ ➜(bold)";
      #  error_symbol = "λ ➜(bold)";
      #};
      add_newline = false;
      "$schema" = "https://starship.rs/config-schema.json";
    };
	};
}
