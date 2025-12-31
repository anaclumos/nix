{ lib, ... }: {
  powerManagement.enable = true;
  services.power-profiles-daemon.enable = true;

  # Logind settings for lid/power button behavior
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchDocked = "suspend-then-hibernate";
    HandleLidSwitchExternalPower = "suspend-then-hibernate";
    HandlePowerKey = "hibernate";
    HandlePowerKeyLongPress = "poweroff";
    IdleAction = "ignore";
    IdleActionSec = 0;
  };

  # Sleep/hibernate configuration
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=10min
    SuspendState=mem
    HibernateMode=shutdown
  '';

  # Zram for compressed memory swap
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  # IO scheduler optimization for NVMe
  services.udev.extraRules = ''
    # Set scheduler for NVMe drives
    ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="none"
    # Set scheduler for SATA SSDs
    ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"
  '';

  # Kernel parameters for better laptop performance
  boot.kernel.sysctl = {
    # Reduce swappiness since we have zram
    "vm.swappiness" = 180; # Higher for zram is recommended
    "vm.vfs_cache_pressure" = 50;

    # Laptop power savings
    "vm.dirty_ratio" = 10;
    "vm.dirty_background_ratio" = 5;

    # Better responsiveness under memory pressure
    "vm.page-cluster" = 0;
  };
}
