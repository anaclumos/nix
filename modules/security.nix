{ lib, ... }: {
  # Firewall configuration
  networking.firewall = {
    enable = true;
    allowPing = true;

    # Allow Tailscale
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ 41641 ]; # Tailscale

    # Steam remote play (configured in gaming.nix but needs firewall)
    # Ports already opened by programs.steam.remotePlay.openFirewall
  };

  # Security hardening
  security = {
    # Prevent replacing the running kernel
    protectKernelImage = true;

    # Strong randomness for crypto
    sudo = {
      execWheelOnly = true;
      extraConfig = ''
        Defaults lecture = never
        Defaults passwd_timeout = 0
      '';
    };

    # Enable polkit for GUI authentication
    polkit.enable = true;

    # PAM configuration
    pam.services = {
      # Allow fingerprint + password for sudo
      sudo.fprintAuth = true;

      # GDM fingerprint support
      gdm-fingerprint.fprintAuth = true;
    };
  };

  # Audit subsystem (lightweight)
  security.auditd.enable = false; # Disabled for laptop performance

  # AppArmor (optional - enable if needed)
  security.apparmor.enable = false;

  # Disable core dumps for security
  systemd.coredump.enable = false;

  # Boot security
  boot.kernel.sysctl = {
    # Prevent unprivileged users from seeing kernel pointers
    "kernel.kptr_restrict" = 2;

    # Restrict dmesg to root
    "kernel.dmesg_restrict" = 1;

    # Restrict perf events
    "kernel.perf_event_paranoid" = 3;

    # Disable kexec
    "kernel.kexec_load_disabled" = 1;

    # Network security
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;

    # TCP hardening
    "net.ipv4.tcp_syncookies" = 1;
    "net.ipv4.tcp_rfc1337" = 1;
  };
}
