{ pkgs, username, ... }:
let homeDir = "/home/${username}";
in {
  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    fastfetch = {
      enable = true;
      settings = {
        modules = [
          "title"
          "separator"
          "os"
          "host"
          "kernel"
          "uptime"
          "packages"
          "shell"
          "display"
          "de"
          "wm"
          "wmtheme"
          "theme"
          "icons"
          "font"
          "cursor"
          "terminal"
          "terminalfont"
          "cpu"
          "gpu"
          "memory"
          "swap"
          "disk"
          "battery"
          "poweradapter"
          "locale"
          "break"
          "colors"
        ];
      };
    };
    atuin = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        auto_sync = true;
        sync_frequency = "1h";
        search_mode = "fuzzy";
        filter_mode = "global";
        update_check = false;
      };
    };
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [ "git" "docker" "npm" "sudo" "command-not-found" ];
      };
      initContent = ''
        fastfetch && if [ "$(pwd)" = "${homeDir}" ]; then cd ~/Desktop; fi
      '';
      shellAliases = {
        build =
          "cd ~/Desktop/nix && nixfmt **/*.nix && nix-channel --update && nix --extra-experimental-features 'nix-command flakes' flake update && sudo NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild switch --flake .#framework --impure && ngc";
        nixgit = ''
          cd ~/Desktop/nix && git commit -m "$(date +"%Y-%m-%d")" -a && git push'';
        ec = "expressvpn connect";
        ed = "expressvpn disconnect";
        x = "exit";
        zz = "code ~/Desktop/nix";
        ss = "source ~/.zshrc";
        cc = "code .";
        sha =
          "git push && echo Done in $(git rev-parse HEAD) | xclip -selection clipboard";
        emptyfolder = "find . -type d -empty -delete";
        npm = "bun";
        npx = "bunx";
        chat = "codex --yolo -c model_reasoning_effort='high'";
        ngc =
          "sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +100 && sudo nix-store --gc";
        airdrop =
          "cd ~/Screenshots && sudo tailscale file cp *.png iphone-17-pro: && rm *.png";
      };
    };
  };
}
