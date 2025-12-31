{ username, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./fonts/default.nix
    ./modules/options.nix
    ./modules/boot.nix
    ./modules/power.nix
    ./modules/input-method.nix
    ./modules/nix-settings.nix
    ./modules/gnome.nix
    ./modules/core.nix
    ./modules/gaming.nix
    ./modules/media.nix
    ./modules/networking.nix
    ./modules/security.nix
  ];
  modules = {
    user.name = username;
    system = {
      hostname = "framework";
      timezone = "Asia/Seoul";
      locale = "en_US.UTF-8";
    };
  };
  services.printing.enable = true;
  system.stateVersion = "25.11";
}
