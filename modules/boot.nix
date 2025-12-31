{ pkgs, ... }: {
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 20;
        editor = false; # Disable boot entry editing for security
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
      timeout = 3;
    };

    # Latest kernel for best hardware support
    kernelPackages = pkgs.linuxPackages_latest;

    # Enable systemd in initrd for faster boot
    initrd = {
      systemd.enable = true;
      verbose = false;

      # LUKS configuration for swap partition
      luks.devices."luks-067d3a16-727c-40f5-8510-a2cb221929cf" = {
        device = "/dev/disk/by-uuid/067d3a16-727c-40f5-8510-a2cb221929cf";
        preLVM = true;
        allowDiscards = true;
        bypassWorkqueues = true; # Better SSD performance
      };
    };

    # Plymouth for graphical boot
    plymouth = {
      enable = true;
      theme = "spinner";
    };

    # Kernel parameters
    kernelParams = [
      "quiet"
      "splash"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "boot.shell_on_fail"
      # AMD-specific
      "amd_pstate=active"
      "amdgpu.ppfeaturemask=0xffffffff" # Enable all power features
    ];

    # Console font for HiDPI
    consoleLogLevel = 0;

    # Tmp on tmpfs for faster operations
    tmp = {
      useTmpfs = true;
      tmpfsSize = "50%";
    };
  };

  # Enable redistributable firmware
  hardware.enableRedistributableFirmware = true;

  # Firmware update daemon
  services.fwupd.enable = true;
}
