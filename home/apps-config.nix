{ ... }: {
  imports = [ ./opencode.nix ];

  home.file.".claude/settings.json" = {
    force = true;
    text = builtins.toJSON { cleanupPeriodDays = 9999999999; } + "\n";
  };

  home.file.".gemini/settings.json" = {
    force = true;
    text = builtins.toJSON {
      general = { sessionRetention = { enabled = false; }; };
    } + "\n";
  };
}