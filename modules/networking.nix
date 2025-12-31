{ ... }: {
  # NetworkManager for connection management
  networking.networkmanager = {
    enable = true;
    wifi.powersave = true;
    dns = "systemd-resolved";
  };

  # Systemd-resolved for DNS
  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade";
    fallbackDns = [ "1.1.1.1" "8.8.8.8" ];
  };

  # VPN services
  services.expressvpn.enable = true;
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  # Local DNS ad-blocking
  services.adguardhome = {
    enable = true;
    mutableSettings = true;
  };
}
