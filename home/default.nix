{
  lib,
  pkgs,
  pkgs-unstable,
  inputs,
  username,
  ...
}:
let
  homeDir = "/home/${username}";
  packages = import ../packages.nix { inherit pkgs pkgs-unstable inputs; };
in
{
  imports = [
    ./shell.nix
    ./git.nix
    ./fcitx.nix
    ./services.nix
    ./autostart.nix
    ./apps-config.nix
    ./gnome-settings.nix
  ];
  home = {
    inherit username;
    homeDirectory = homeDir;
    stateVersion = "25.11";
    language = {
      base = "en_US.UTF-8";
      address = "en_US.UTF-8";
      measurement = "en_US.UTF-8";
      monetary = "en_US.UTF-8";
      time = "en_US.UTF-8";
    };
    packages = lib.unique (
      packages.developmentTools
      ++ packages.mediaTools
      ++ packages.applications
      ++ packages.gnomeTools
      ++ packages.systemTools
      ++ packages.cloudTools
      ++ packages.iconThemes
      ++ packages.gnomeExtensionsList
    );
  };
  fonts.fontconfig.enable = false;
  programs.home-manager.enable = true;
}
