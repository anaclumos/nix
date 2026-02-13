{ lib, ... }:
{
  dconf.enable = true;
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      show-battery-percentage = true;
      font-name = "Pretendard GOV 12";
      document-font-name = "Pretendard GOV 12";
      monospace-font-name = "Iosevka 12";
      icon-theme = "Colloid";
      cursor-theme = "elementary";
      clock-show-weekday = true;
      clock-format = "12h";
      enable-hot-corners = false;
    };
    "org/gnome/desktop/wm/preferences" = {
      titlebar-font = "Pretendard GOV 12";
    };
    "org/gnome/system/locale" = {
      region = "en_US.UTF-8";
    };
    "org/gnome/shell" = {
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "google-chrome.desktop"
        "thunderbird.desktop"
        "spotify.desktop"
        "org.gnome.Calendar.desktop"
        "code.desktop"
        "obsidian.desktop"
        "slack.desktop"
        "kakaotalk.desktop"
        "tableplus.desktop"
      ];
      enabled-extensions = [
        "unite@hardpixel.eu"
        "clipboard-history@alexsaveau.dev"
        "appindicatorsupport@rgcjonas.gmail.com"
        "kimpanel@kde.org"
        "dash-to-dock@micxgx.gmail.com"
        "mediacontrols@cliffniff.github.com"
        "ding@rastersoft.com"
        "blur-my-shell@aunetx"
      ];
    };
    "org/gnome/shell/extensions/clipboard-history" = {
      toggle-menu = [ "<Control>g" ];
    };
    "org/gnome/shell/extensions/unite" = {
      app-menu-ellipsize-mode = "end";
      extend-left-box = false;
      hide-activities-button = "always";
      hide-window-titlebars = "never";
      icon-scale-workaround = true;
      notifications-position = "center";
      reduce-panel-spacing = true;
      show-appmenu-button = false;
      show-desktop-name = false;
      show-legacy-tray = true;
      show-window-buttons = "never";
      show-window-title = "never";
      use-activities-text = true;
    };
    "org/gnome/shell/extensions/mediacontrols" = {
      colored-player-icon = true;
      extension-position = "Left";
      fixed-label-width = false;
      hide-media-notification = false;
      label-width = lib.hm.gvariant.mkUint32 500;
      labels-order = [ "TITLE" ];
      scroll-labels = false;
      show-control-icons = false;
      show-label = true;
      show-player-icon = true;
      show-track-slider = false;
    };
    "org/gnome/shell/extensions/dash-to-dock" = {
      dock-fixed = false;
      dock-position = "BOTTOM";
      extend-height = false;
      intellihide = true;
      intellihide-mode = "MAXIMIZED_WINDOWS";
      autohide = true;
      show-trash = true;
      show-mounts = true;
      hotkeys-overlay = false;
      hotkeys-show-dock = false;
      multi-monitor = false;
      preferred-monitor = -2;
      preferred-monitor-by-connector = "eDP-1";
    };
    "org/gnome/shell/extensions/blur-my-shell" = {
      pipelines-version = 3;
    };
    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      blur = false;
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/spotlight/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/jira/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/lock/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/1password/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/dark-mode/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/kakaotalk/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/spotlight" = {
      name = "GNOME Overview";
      command = "bash -c 'dbus-send --session --dest=org.gnome.Shell --type=method_call /org/gnome/Shell org.freedesktop.DBus.Properties.Set string:org.gnome.Shell string:OverviewActive variant:boolean:true'";
      binding = "<Ctrl>space";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/jira" = {
      name = "Open Jira";
      command = "xdg-open https://lunit.atlassian.net/jira/core/projects/INCL2";
      binding = "<Ctrl><Alt><Super><Shift>i";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/lock" = {
      name = "Lock Screen";
      command = "dbus-send --type=method_call --dest=org.gnome.ScreenSaver /org/gnome/ScreenSaver org.gnome.ScreenSaver.Lock";
      binding = "<Ctrl>l";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/1password" = {
      name = "1Password Quick Access";
      command = "1password --quick-access";
      binding = "<Ctrl><Shift>space";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/dark-mode" = {
      name = "Toggle Dark Mode";
      command = "bash -c 'if gsettings get org.gnome.desktop.interface color-scheme | grep -q dark; then gsettings set org.gnome.desktop.interface color-scheme default; else gsettings set org.gnome.desktop.interface color-scheme prefer-dark; fi'";
      binding = "<Ctrl><Alt><Super><Shift>grave";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/kakaotalk" = {
      name = "Launch or Focus KakaoTalk";
      command = "gio launch kakaotalk.desktop";
      binding = "<Ctrl><Alt><Super><Shift>m";
    };
  };
}
