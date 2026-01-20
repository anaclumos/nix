{ pkgs-unstable, ... }:
let
  opencodeConfig = {
    "$schema" = "https://opencode.ai/config.json";
    plugin = [ "oh-my-opencode" ];
  };
  ohMyOpencodeConfig = {
    google_auth = true;
    agents = {
      orchestrator-sisyphus = {
        model = "openai/gpt-5.2-codex";
        variant = "xhigh";
      };
    };
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

  xdg.configFile."opencode/package.json" = {
    force = true;
    text = builtins.toJSON opencodePackageJson + "\n";
  };

  home.activation.installOpencodePlugins = {
    after = [
      "writeBoundary"
      "linkGeneration"
    ];
    before = [ ];
    data = ''
      if [ -f "$HOME/.config/opencode/package.json" ]; then
        ${pkgs-unstable.bun}/bin/bun install --cwd "$HOME/.config/opencode" 2>/dev/null || true
      fi
    '';
  };
}
