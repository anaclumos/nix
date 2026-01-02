{ pkgs, ... }:
{
  xdg.configFile = {
    "autostart/1password.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Exec=${pkgs._1password-gui}/bin/1password --silent
      Hidden=false
      NoDisplay=false
      X-GNOME-Autostart-enabled=true
      Name=1Password
      Comment=Password manager and secure wallet
    '';
    "1password/1password-bw-integration".text = "";
  };
}
