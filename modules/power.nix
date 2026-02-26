_: {
  powerManagement.enable = true;

  services = {
    power-profiles-daemon.enable = true;

    udev.extraRules = ''
      ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="none"
      ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"
    '';

    earlyoom = {
      enable = true;
      freeMemThreshold = 2;
      freeSwapThreshold = 2;
      enableNotifications = true;
    };
  };

  systemd.sleep.extraConfig = ''
    SuspendState=mem
  '';

  # --- zram: fast compressed swap in RAM ---
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
    priority = 100;
  };

  # --- NVMe swap file: bulk swap capacity for 1TB workloads ---
  # Creates a 912G swap file on the NVMe drive.
  # After first boot with this config, run:
  #   sudo fallocate -l 912G /swap/swapfile
  #   sudo chmod 0600 /swap/swapfile
  #   sudo mkswap /swap/swapfile
  #   sudo swapon /swap/swapfile
  systemd.tmpfiles.rules = [
    "d /swap 0755 root root -"
  ];

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 912 * 1024; # 912 GB in MB
      priority = 10; # lower than zram so zram is preferred
    }
  ];

  boot.kernel.sysctl = {
    # --- Dirty Page Management ---
    # Use absolute bytes instead of ratios to prevent IO death spirals.
    # On a 96GB system, 10% dirty_ratio = ~10GB of dirty data to flush at once.
    # With heavy swap, this would destroy NVMe throughput.
    "vm.dirty_background_bytes" = 268435456; # 256MB: start background writeback early
    "vm.dirty_bytes" = 1073741824; # 1GB: force synchronous writes before this

    # --- Swap & Cache Behavior ---
    # swappiness=180: aggressive swap-to-zram. Since zram is compressed RAM,
    # it's faster to compress+swap than to evict file cache pages.
    # Values >100 are specifically designed for zram/zswap setups.
    "vm.swappiness" = 180;
    # Keep VFS metadata (dentries/inodes) cached longer — good for nix builds
    "vm.vfs_cache_pressure" = 50;

    # --- Memory Overcommit ---
    # Mode 1: always allow allocations. Required for programs that allocate
    # ~1TB address space. The kernel won't refuse malloc() even if physical
    # RAM + swap < requested. Actual pages are only allocated on access.
    "vm.overcommit_memory" = 1;

    # --- Allocation Safety ---
    # Reserve 1GB for kernel/atomic allocations to prevent deadlocks
    # under extreme memory pressure. Default (~67MB) is far too low
    # when 1TB of pages are being shuffled between RAM and swap.
    "vm.min_free_kbytes" = 1048576; # 1GB

    # --- Process Limits ---
    # Large memory workloads often use many memory-mapped regions.
    # Default 65530 is too low for programs with 1TB address spaces.
    "vm.max_map_count" = 1048576;
    "fs.file-max" = 2097152;
    "kernel.pid_max" = 4194304;
  };
}
