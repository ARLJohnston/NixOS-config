{
  description = "My system configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors = {
      url = "github:misterio77/nix-colors";
    };

    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
    };

  in
  {
  nixosConfigurations = {
    thinkpad = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs system; };

      modules = [
        ./nixos/configuration.nix
      ];
    };
  };

  homeConfigurations = {
    alistair = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit inputs system; };

      modules = [./nixos/home.nix];
    };
  };

  };
}
