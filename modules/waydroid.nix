{ config, lib, pkgs, pkgs-unstable, ... }:

let
  # Galaxy Tab S7 (SM-T870) - confirmed KakaoTalk tablet mode support
  # Source: https://www.clien.net/service/board/park/15833435
  deviceProps = {
    # Product identification
    "ro.product.brand" = "samsung";
    "ro.product.device" = "gts7lwifi";
    "ro.product.manufacturer" = "samsung";
    "ro.product.model" = "SM-T870";
    "ro.product.name" = "gts7lwifixx";

    # Waydroid-specific product props
    "ro.product.waydroid.brand" = "samsung";
    "ro.product.waydroid.device" = "gts7lwifi";
    "ro.product.waydroid.manufacturer" = "samsung";
    "ro.product.waydroid.model" = "SM-T870";
    "ro.product.waydroid.name" = "gts7lwifixx";

    # Build characteristics (critical for tablet detection)
    "ro.build.characteristics" = "tablet";
    "ro.build.product" = "gts7lwifi";
    "ro.build.flavor" = "gts7lwifixx-user";
    "ro.build.description" =
      "gts7lwifixx-user 13 TP1A.220624.014 T870XXS2CWK1 release-keys";

    # Fingerprints (for app compatibility)
    "ro.build.fingerprint" =
      "samsung/gts7lwifixx/gts7lwifi:13/TP1A.220624.014/T870XXS2CWK1:user/release-keys";
    "ro.system.build.fingerprint" =
      "samsung/gts7lwifixx/gts7lwifi:13/TP1A.220624.014/T870XXS2CWK1:user/release-keys";
    "ro.vendor.build.fingerprint" =
      "samsung/gts7lwifixx/gts7lwifi:13/TP1A.220624.014/T870XXS2CWK1:user/release-keys";
    "ro.bootimage.build.fingerprint" =
      "samsung/gts7lwifixx/gts7lwifi:13/TP1A.220624.014/T870XXS2CWK1:user/release-keys";
    "ro.odm.build.fingerprint" =
      "samsung/gts7lwifixx/gts7lwifi:13/TP1A.220624.014/T870XXS2CWK1:user/release-keys";

    # Additional build props
    "ro.build.tags" = "release-keys";
    "ro.build.type" = "user";
    "ro.build.display.id" = "TP1A.220624.014.T870XXS2CWK1";
    "ro.build.id" = "TP1A.220624.014";
    "ro.build.version.release" = "13";
    "ro.build.version.sdk" = "33";

    # Vendor build props
    "ro.vendor.build.tags" = "release-keys";
    "ro.vendor.build.type" = "user";
    "ro.vendor.build.id" = "TP1A.220624.014";

    # System build props
    "ro.system.build.product" = "gts7lwifi";
    "ro.system.build.flavor" = "gts7lwifixx-user";

    # Hardware identification
    "ro.hardware" = "exynos990";
    "ro.board.platform" = "exynos990";

    # Display density for tablet
    "ro.sf.lcd_density" = "240";
  };

  # Convert attrset to prop file content
  propsContent = lib.concatStringsSep "\n"
    (lib.mapAttrsToList (k: v: "${k}=${v}") deviceProps);

  # Waydroid script directory (persistent UV environment)
  waydroidScriptDir = "/var/lib/waydroid-script";

  # Waydroid initialization and setup script
  waydroidSetupScript = pkgs.writeShellScriptBin "waydroid-setup-kakaotalk" ''
        set -e

        WAYDROID_DIR="/var/lib/waydroid"
        PROP_FILE="$WAYDROID_DIR/waydroid_base.prop"

        echo "=== Waydroid KakaoTalk Tablet Setup ==="
        echo ""

        # Check if running as root for prop file modification
        if [ "$EUID" -ne 0 ]; then
          echo "Please run with sudo: sudo waydroid-setup-kakaotalk"
          exit 1
        fi

        # Check if Waydroid is initialized
        if [ ! -f "$WAYDROID_DIR/waydroid.cfg" ]; then
          echo "Waydroid not initialized. Initializing with GAPPS..."
          waydroid init -s GAPPS
          echo ""
        fi

        echo "Setting up Galaxy Tab S7 (SM-T870) device properties..."
        echo "This device is confirmed to support KakaoTalk tablet mode."
        echo ""

        # Backup existing props if any
        if [ -f "$PROP_FILE" ]; then
          BACKUP="$PROP_FILE.backup.$(date +%s)"
          cp "$PROP_FILE" "$BACKUP"
          echo "Backed up existing props to: $BACKUP"
        fi

        # Write device properties
        cat > "$PROP_FILE" << 'PROPS'
    ${propsContent}
    PROPS

        echo "Device properties written to $PROP_FILE"
        echo ""

        # Set Waydroid display properties for tablet (only if waydroid is initialized)
        if [ -f "$WAYDROID_DIR/waydroid.cfg" ]; then
          echo "Setting tablet display properties..."
          waydroid prop set persist.waydroid.width 1600 || true
          waydroid prop set persist.waydroid.height 2560 || true
          waydroid prop set persist.waydroid.fake_touch "com.kakao.talk" || true
          waydroid prop set persist.waydroid.fake_wifi "com.kakao.talk" || true
        fi

        echo ""
        echo "=== Setup Complete ==="
        echo ""
        echo "Next steps:"
        echo "  1. Install ARM translation: sudo waydroid-install-arm"
        echo "  2. Restart session: waydroid session stop && waydroid session start"
        echo "  3. Launch UI: waydroid show-full-ui"
        echo "  4. Install KakaoTalk from Play Store"
        echo ""
  '';

  # ARM translation installer script using UV
  armTranslationScript = pkgs.writeShellScriptBin "waydroid-install-arm" ''
    set -e

    SCRIPT_DIR="${waydroidScriptDir}"

    echo "=== Waydroid ARM Translation Installer ==="
    echo ""
    echo "This installs libhoudini for ARM app compatibility (required for KakaoTalk)."
    echo "Using UV for Python environment management."
    echo ""

    # Ensure we have sudo
    if [ "$EUID" -ne 0 ]; then
      echo "Please run with sudo: sudo waydroid-install-arm"
      exit 1
    fi

    # Create persistent directory for waydroid_script
    mkdir -p "$SCRIPT_DIR"
    cd "$SCRIPT_DIR"

    # Clone or update waydroid_script
    if [ -d "$SCRIPT_DIR/waydroid_script" ]; then
      echo "Updating waydroid_script..."
      cd waydroid_script
      ${pkgs.git}/bin/git pull --ff-only || true
    else
      echo "Cloning waydroid_script..."
      ${pkgs.git}/bin/git clone --depth 1 https://github.com/casualsnek/waydroid_script.git
      cd waydroid_script
    fi

    echo ""
    echo "Setting up UV environment and installing dependencies..."

    # Use UV with managed Python (auto-downloads Python if needed)
    ${pkgs-unstable.uv}/bin/uv venv --python 3.12 .venv
    ${pkgs-unstable.uv}/bin/uv pip install -r requirements.txt

    echo ""
    echo "Installing libhoudini (ARM translation)..."
    ${pkgs-unstable.uv}/bin/uv run python main.py install libhoudini

    echo ""
    echo "=== ARM Translation Installed ==="
    echo ""
    echo "Restart Waydroid session to apply:"
    echo "  waydroid session stop && waydroid session start"
    echo ""
  '';

  # Google Play certification script using UV
  playCertScript = pkgs.writeShellScriptBin "waydroid-certify-play" ''
    set -e

    SCRIPT_DIR="${waydroidScriptDir}"

    echo "=== Waydroid Google Play Certification ==="
    echo ""

    # Ensure we have sudo
    if [ "$EUID" -ne 0 ]; then
      echo "Please run with sudo: sudo waydroid-certify-play"
      exit 1
    fi

    cd "$SCRIPT_DIR/waydroid_script" 2>/dev/null || {
      echo "waydroid_script not found. Run waydroid-install-arm first."
      exit 1
    }

    echo "Registering device with Google..."
    ${pkgs-unstable.uv}/bin/uv run python main.py certified

    echo ""
    echo "=== Follow the instructions above to complete certification ==="
    echo ""
  '';

  # Quick launch script
  waydroidLaunchScript = pkgs.writeShellScriptBin "waydroid-kakaotalk" ''
    # Ensure session is running
    if ! waydroid status 2>/dev/null | grep -q "Session.*RUNNING"; then
      echo "Starting Waydroid session..."
      waydroid session start &
      sleep 3
    fi

    # Launch KakaoTalk directly or full UI
    if waydroid app list 2>/dev/null | grep -q "com.kakao.talk"; then
      waydroid app launch com.kakao.talk
    else
      echo "KakaoTalk not installed. Launching full UI..."
      waydroid show-full-ui
    fi
  '';

in {
  # Enable Waydroid virtualization
  virtualisation.waydroid.enable = true;

  # Add helper scripts to system packages
  environment.systemPackages = [
    waydroidSetupScript
    armTranslationScript
    playCertScript
    waydroidLaunchScript
    pkgs.git
  ];

  # Systemd service to apply device props on boot (after Waydroid is initialized)
  systemd.services.waydroid-device-props = {
    description = "Apply Waydroid device properties for KakaoTalk tablet mode";
    after = [ "waydroid-container.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
            PROP_FILE="/var/lib/waydroid/waydroid_base.prop"

            # Only apply if Waydroid is initialized
            [ -d /var/lib/waydroid ] || exit 0
            [ -f /var/lib/waydroid/waydroid.cfg ] || exit 0

            # Write device properties
            cat > "$PROP_FILE" << 'EOF'
      ${propsContent}
      EOF
    '';
  };
}
