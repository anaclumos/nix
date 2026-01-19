{
  pkgs,
  pkgs-unstable,
  inputs,
}:
let
  customPackages = {
    kakaotalk = pkgs-unstable.callPackage ./pkgs/kakaotalk.nix { inherit inputs; };
    tableplus = pkgs-unstable.callPackage ./pkgs/tableplus.nix { inherit inputs; };
  };

  developmentTools = with pkgs-unstable; [
    nodejs
    bun
    uv
    ruff
    pnpm
    nodePackages.vercel
    cmake
    gcc
    gnumake
    pkg-config
    moon
    lefthook
    claude-code
    vscode
    vscode-extensions.biomejs.biome
    gh
    terraform
    tree
    argocd
    k9s
    kubectl
    (azure-cli.withExtensions [
      azure-cli.extensions.bastion
      azure-cli.extensions.ssh
    ])
    azure-storage-azcopy
    codex
    opencode
    nixfmt
    nil
    statix
    deadnix
    nix-diff
    comma
    nix-index
    mariadb
    scc
    whois
    unzip
    zip
    p7zip
    act
    biome
    lsof
    tmux
    wget
    jq
    openssl
    librsvg
    iw
    pngcrush
    imagemagick
    pngquant
    tectonic
    tex-fmt
    cacert
    docker-compose
    _1password-cli
    ollama
    ramalama
    nvfetcher
  ];
  mediaTools = with pkgs-unstable; [
    ffmpeg-full
    libheif
    libsndfile
  ];
  applications = with pkgs; [
    slack
    teams-for-linux
    beeper
    zoom-us
    telegram-desktop
    customPackages.kakaotalk
    (google-chrome.override {
      commandLineArgs = [
        "--ozone-platform-hint=wayland"
        "--enable-features=TouchpadOverscrollHistoryNavigation,UseOzonePlatform"
        "--disable-smooth-scrolling"
      ];
    })
    obsidian
    logseq
    sticky-notes
    spotify
    _1password-gui
    expressvpn
    caffeine-ng
    timewall
    trayscale
    sqlitebrowser
    customPackages.tableplus
    geekbench
    gitify
  ];
  gnomeTools = with pkgs; [ refine ];
  systemTools = with pkgs; [
    xclip
    wmctrl
    xdotool
    pciutils
    nvme-cli
    btop
    libnotify
  ];
  cloudTools = with pkgs; [
    (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
  ];
  iconThemes = with pkgs; [
    pantheon.elementary-icon-theme
    hicolor-icon-theme
    adwaita-icon-theme
    colloid-icon-theme
  ];
  gnomeExtensionsList = with pkgs; [
    gnomeExtensions.unite
    gnomeExtensions.clipboard-history
    gnomeExtensions.appindicator
    gnomeExtensions.media-controls
    gnomeExtensions.kimpanel
    gnomeExtensions.dash-to-dock
    gnomeExtensions.desktop-icons-ng-ding
    gnomeExtensions.blur-my-shell
  ];
in
{
  inherit
    developmentTools
    mediaTools
    applications
    gnomeTools
    systemTools
    cloudTools
    iconThemes
    gnomeExtensionsList
    ;
}
