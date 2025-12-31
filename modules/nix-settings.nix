{ config, pkgs, ... }: {
  nix = {
    # Enable flakes and new nix command
    settings = {
      experimental-features = [ "nix-command" "flakes" ];

      # Optimize store automatically
      auto-optimise-store = true;

      # Allow wheel group to use nix
      trusted-users = [ "root" "@wheel" ];

      # Faster builds with more cores
      max-jobs = "auto";
      cores = 0; # Use all available cores

      # Better download behavior
      connect-timeout = 5;
      log-lines = 25;

      # Fallback to building if binary cache fails
      fallback = true;

      # Warn on dirty git tree
      warn-dirty = false;

      # Keep build dependencies for debugging
      keep-outputs = true;
      keep-derivations = true;

      # Substituters (binary caches)
      substituters =
        [ "https://cache.nixos.org" "https://nix-community.cachix.org" ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    # Automatic garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    # Optimize store periodically
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };

  # Enable nix-ld for running unpatched binaries
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      zlib
      fuse3
      icu
      nss
      openssl
      curl
      expat
      libsndfile
    ];
  };

  # Useful Nix-related packages
  environment.systemPackages = with pkgs; [
    nix-output-monitor # Better build output
    nvd # Diff generations
    nix-tree # Explore dependencies
  ];
}
