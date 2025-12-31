{
  description = "NixOS configuration for Sunghyun's systems";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kakaotalk.url = "github:anaclumos/kakaotalk.nix";
    tableplus.url = "github:anaclumos/tableplus.nix";
    unms-research.url = "github:anaclumos/unms-research.nix";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };
  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, nixos-hardware, ... }:
    let
      system = "x86_64-linux";
      username = "sunghyun";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations = {
        framework = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs username; };
          modules = [
            { nixpkgs.config.allowUnfree = true; }
            nixos-hardware.nixosModules.framework-amd-ai-300-series
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useUserPackages = true;
              home-manager.users.${username} = import ./home;
              home-manager.extraSpecialArgs = {
                inherit inputs username pkgs-unstable;
              };
              home-manager.sharedModules =
                [{ nixpkgs.config.allowUnfree = true; }];
            }
          ];
        };
      };
      formatter.${system} = pkgs.nixfmt-classic;
    };
}