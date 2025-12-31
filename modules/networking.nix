{ pkgs, ... }: {
  services.expressvpn.enable = true;
  networking.networkmanager.enable = true;
  services.tailscale.enable = true;
  services.adguardhome.enable = true;

  boot.kernelModules = [ "iwlwifi" ];

  networking.networkmanager.wifi = {
    powersave = false;
    scanRandMacAddress = false;
    backend = "wpa_supplicant";
  };

  boot.extraModprobeConfig = ''
    options iwlwifi power_save=0
    options iwlmvm power_scheme=1
  '';
}
