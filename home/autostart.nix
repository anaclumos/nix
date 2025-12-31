{ pkgs, ... }: {
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
    "autostart/trayscale.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Exec=${pkgs.trayscale}/bin/trayscale --hide-window
      Hidden=false
      NoDisplay=false
      X-GNOME-Autostart-enabled=true
      Name=Trayscale
      Comment=Tailscale GUI
    '';
    "1password/1password-bw-integration".text = "";
  };
}
