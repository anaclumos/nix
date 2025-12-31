{ ... }: {
  powerManagement.enable = true;
  services.power-profiles-daemon.enable = true;
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchDocked = "suspend-then-hibernate";
    HandleLidSwitchExternalPower = "suspend-then-hibernate";
    HandlePowerKey = "hibernate";
    HandlePowerKeyLongPress = "poweroff";
    IdleAction = "ignore";
    IdleActionSec = "0";
  };
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=10min
    SuspendState=mem
    HibernateMode=shutdown
  '';
}
