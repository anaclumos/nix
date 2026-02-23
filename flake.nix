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
    sunghyun-sans = {
      url = "github:anaclumos/sunghyun-sans";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nixos-hardware,
      ...
    }:
    let
      system = "x86_64-linux";
      username = "sunghyun";

      mkPkgs =
        nixpkgsInput:
        import nixpkgsInput {
          inherit system;
          config.allowUnfree = true;
        };

      pkgs = mkPkgs nixpkgs;
      pkgs-unstable = mkPkgs nixpkgs-unstable;

      extraArgs = { inherit inputs username pkgs-unstable; };
      allowUnfreeModule = {
        nixpkgs.config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.framework = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = extraArgs;
        modules = [
          allowUnfreeModule
          nixos-hardware.nixosModules.framework-amd-ai-300-series
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = false;
              users.${username} = import ./home;
              extraSpecialArgs = extraArgs;
              sharedModules = [ allowUnfreeModule ];
            };
          }
        ];
      };

      formatter.${system} = pkgs.nixfmt;
    };
}
