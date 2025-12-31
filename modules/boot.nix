{ pkgs, ... }: {
  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 20;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.systemd.enable = true;
    initrd.luks.devices."luks-067d3a16-727c-40f5-8510-a2cb221929cf" = {
      device = "/dev/disk/by-uuid/067d3a16-727c-40f5-8510-a2cb221929cf";
      preLVM = true;
      allowDiscards = true;
    };
  };
  hardware.enableRedistributableFirmware = true;
  services.fwupd.enable = true;
}
