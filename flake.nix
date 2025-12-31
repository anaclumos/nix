{
  description = "NixOS configuration for Sunghyun's systems";

  nixConfig = {
    extra-substituters =
      [ "https://nix-community.cachix.org" "https://cache.nixos.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # External packages
    kakaotalk.url = "github:anaclumos/kakaotalk.nix";
    tableplus.url = "github:anaclumos/tableplus.nix";
    unms-research.url = "github:anaclumos/unms-research.nix";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager
    , nixos-hardware, ... }:
    let
      system = "x86_64-linux";
      username = "sunghyun";

      # Package sets with unfree allowed
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      # Shared special args for both NixOS and Home Manager
      specialArgs = { inherit inputs username; };

      # Home Manager extra args
      homeExtraArgs = { inherit inputs username pkgs-unstable; };
    in {
      # NixOS configurations
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

      # Development shell for working with this config
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
        shellHook = ''
          echo "NixOS config development shell"
          echo "Available commands:"
          echo "  nixfmt - Format nix files"
          echo "  statix - Lint nix files"
          echo "  deadnix - Find dead code"
          echo "  nix-tree - Explore dependencies"
          echo "  nvd - Compare generations"
        '';
      };

      # Formatter for nix fmt
      formatter.${system} = pkgs.nixfmt-rfc-style;

    };
}
