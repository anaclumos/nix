{
  config,
  lib,
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "thunderbolt"
        "usb_storage"
        "sd_mod"
      ];
      kernelModules = [ ];
      luks.devices."luks-6afa55ab-b57d-4bae-8882-6acf6d5d8886".device =
        "/dev/disk/by-uuid/6afa55ab-b57d-4bae-8882-6acf6d5d8886";
    };
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
  };
  fileSystems = {
    "/" = {
      device = "/dev/mapper/luks-6afa55ab-b57d-4bae-8882-6acf6d5d8886";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/5078-0B2A";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };
  };
  swapDevices = [ ];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
