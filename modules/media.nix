_: {
  services = {
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    xserver.videoDrivers = [ "amdgpu" ];
  };
  security.rtkit.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
