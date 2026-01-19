{
  lib,
  pkgs,
  pkgs-unstable,
  inputs,
  username,
  osConfig ? null,
  ...
}:
let
  homeDir = "/home/${username}";
  packageSets = import ../packages.nix { inherit pkgs pkgs-unstable inputs; };

  packageToggles =
    if osConfig != null && osConfig ? modules && osConfig.modules ? packages then
      osConfig.modules.packages
    else
      {
        enableDevelopment = true;
        enableMedia = true;
        enableCloud = true;
      };
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
      packageSets.applications
      ++ packageSets.gnomeTools
      ++ packageSets.systemTools
      ++ packageSets.iconThemes
      ++ packageSets.gnomeExtensionsList
      ++ lib.optionals packageToggles.enableDevelopment packageSets.developmentTools
      ++ lib.optionals packageToggles.enableMedia packageSets.mediaTools
      ++ lib.optionals packageToggles.enableCloud packageSets.cloudTools
    );
  };
  fonts.fontconfig.enable = false;
  programs.home-manager.enable = true;
}
