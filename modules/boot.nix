{ pkgs, ... }:
{
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
      # Use THP only when applications explicitly request it (madvise).
      # 'always' can cause latency spikes during compaction under memory pressure.
      "transparent_hugepage=madvise"
    ];

    consoleLogLevel = 0;

    tmp = {
      useTmpfs = true;
      # Cap tmpfs to 32GB. Default 50% would be ~48GB of physical RAM,
      # but under heavy swap pressure that memory is better used for the workload.
      tmpfsSize = "32G";
    };
  };

  hardware.enableRedistributableFirmware = true;
  services.fwupd.enable = true;
}
