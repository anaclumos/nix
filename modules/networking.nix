_: {
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
    dns = "systemd-resolved";
    settings.connectivity.uri = "http://nmcheck.gnome.org/check_network_status.txt";
  };

  networking.wireless.iwd.enable = true;

  services = {
    resolved = {
      enable = true;
      dnssec = "allow-downgrade";
      fallbackDns = [
        "1.1.1.1"
        "8.8.8.8"
      ];
    };

    expressvpn.enable = true;
    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };
  };
}
