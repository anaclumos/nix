{ pkgs-unstable, ... }:
let
  opencodeConfig = {
    "$schema" = "https://opencode.ai/config.json";
    plugin = [ "oh-my-opencode" ];
  };
  ohMyOpencodeConfig = {
    google_auth = true;
  };
  opencodePackageJson = {
    dependencies = {
      "oh-my-opencode" = "beta";
    };
  };
in
{
  xdg.configFile."opencode/opencode.json" = {
    force = true;
    text = builtins.toJSON opencodeConfig + "\n";
  };

  xdg.configFile."opencode/oh-my-opencode.json" = {
    force = true;
    text = builtins.toJSON ohMyOpencodeConfig + "\n";
  };

  home.activation.installOpencodePlugins = {
    after = [
      "writeBoundary"
      "linkGeneration"
    ];
    before = [ ];
    data = ''
      OPENCODE_DIR="$HOME/.config/opencode"
      mkdir -p "$OPENCODE_DIR"
      rm -f "$OPENCODE_DIR/package.json"
      printf '%s\n' '${builtins.toJSON opencodePackageJson}' > "$OPENCODE_DIR/package.json"
      ${pkgs-unstable.bun}/bin/bun install --cwd "$OPENCODE_DIR" 2>/dev/null || true
    '';
  };
}
