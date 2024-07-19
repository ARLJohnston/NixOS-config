{
  description = "My system configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors = { url = "github:misterio77/nix-colors"; };

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, emacs-overlay, ... }@inputs:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs { inherit system; };
    in {
      nixosConfigurations = {
        thinkpad = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs system; };
          modules = [ ./nixos/configuration.nix ];
        };
      };

      homeConfigurations = {
        alistair = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs system; };
          modules = [ ./nixos/home.nix ];
        };
      };

      devShells.${system}.default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [ nixpkgs-fmt nixfmt nil ];
      };
    };
}
