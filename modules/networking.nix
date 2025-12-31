_: {
  networking.networkmanager = {
    enable = true;
    wifi.powersave = true;
    dns = "systemd-resolved";
  };

  services = {
    resolved = {
      enable = true;
      dnssec = "allow-downgrade";
      fallbackDns = [ "1.1.1.1" "8.8.8.8" ];
    };

    expressvpn.enable = true;
    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };
  };
}
