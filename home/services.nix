{ pkgs, ... }:
let
  tb = pkgs.thunderbird-latest;
  tb-ui = pkgs.writeShellScriptBin "thunderbird-ui" ''
    systemctl --user stop thunderbird-headless.service 2>/dev/null || true
    "${tb}/bin/thunderbird" "$@"
    systemctl --user start thunderbird-headless.service
  '';
in
{
  home.packages = [
    tb
    tb-ui
  ];
  services.mpris-proxy.enable = true;
  systemd.user.services.timewall = {
    Unit = {
      Description = "Timewall - Dynamic HEIF wallpaper daemon";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.timewall}/bin/timewall set --daemon '${../wallpaper/solar-gradient.heic}'";
      Restart = "always";
      RestartSec = "10";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
  xdg.configFile."timewall/config.toml" = {
    text = ''
      [location]
      lat = 37.5665
      lon = 126.9780
    '';
    force = true;
  };
  systemd.user.services.thunderbird-headless = {
    Unit = {
      Description = "Thunderbird headless (background mail checks + notifications)";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${tb}/bin/thunderbird --headless";
      Restart = "on-failure";
      Environment = [
        "DISPLAY=:0"
        "WAYLAND_DISPLAY=wayland-0"
      ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
  xdg.desktopEntries.thunderbird = {
    name = "Thunderbird";
    exec = "thunderbird-ui %u";
    terminal = false;
    icon = "thunderbird";
    type = "Application";
    categories = [
      "Network"
      "Email"
    ];
    startupNotify = true;
  };
}
