{ pkgs, ... }: {
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 20;
        editor = false;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
      timeout = 3;
    };

    kernelPackages = pkgs.linuxPackages_latest;

    initrd = {
      systemd.enable = true;
      verbose = false;
    };

    plymouth = {
      enable = true;
      theme = "spinner";
    };

    kernelParams = [
      "quiet"
      "splash"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "boot.shell_on_fail"
      "amd_pstate=active"
      "amdgpu.ppfeaturemask=0xffffffff"
    ];

    consoleLogLevel = 0;

    tmp = {
      useTmpfs = true;
      tmpfsSize = "50%";
    };
  };

  hardware.enableRedistributableFirmware = true;
  services.fwupd.enable = true;
}
