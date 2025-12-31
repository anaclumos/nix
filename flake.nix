{
  description = "NixOS configuration for Sunghyun's systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    kakaotalk = {
      url = "github:anaclumos/kakaotalk.nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    tableplus = {
      url = "github:anaclumos/tableplus.nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    inputs@{ nixpkgs, nixpkgs-unstable, home-manager, nixos-hardware, ... }:
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

      specialArgs = { inherit inputs username; };

      homeExtraArgs = { inherit inputs username pkgs-unstable; };
    in {
      nixosConfigurations = {
        framework = nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            { nixpkgs.config.allowUnfree = true; }
            nixos-hardware.nixosModules.framework-amd-ai-300-series
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useUserPackages = true;
                useGlobalPkgs = false;
                users.${username} = import ./home;
                extraSpecialArgs = homeExtraArgs;
                sharedModules = [{ nixpkgs.config.allowUnfree = true; }];
              };
            }
          ];
        };
      };

      devShells.${system}.default = pkgs.mkShell {
        name = "nixos-config";
        packages = with pkgs; [
          nixfmt-rfc-style
          nil
          statix
          deadnix
          nix-tree
          nvd
          nix-diff
        ];
      };

      formatter.${system} = pkgs.nixfmt-rfc-style;

    };
}
