{
  lib,
  stdenv,
  fetchFromGitHub,
  dialog,
  glib,
  gnome-themes-extra,
  jdupes,
  libxml2,
  sassc,
  util-linux,
  colorVariants ? [ ],
  opacityVariants ? [ ],
  themeVariants ? [ ],
  schemeVariants ? [ ],
  altVariants ? [ ],
  iconVariant ? null,
  panelOpacity ? null,
  panelSize ? null,
  roundedMaxWindow ? false,
  darkerColor ? false,
  blur ? false,
}:

let
  pname = "mactahoe-gtk-theme";
  single = x: lib.optional (x != null) x;
in

lib.checkListOfEnum "${pname}: color variants" [ "light" "dark" ] colorVariants lib.checkListOfEnum
  "${pname}: opacity variants"
  [ "normal" "solid" ]
  opacityVariants
  lib.checkListOfEnum
  "${pname}: accent color variants"
  [
    "default"
    "blue"
    "purple"
    "pink"
    "red"
    "orange"
    "yellow"
    "green"
    "grey"
    "all"
  ]
  themeVariants
  lib.checkListOfEnum
  "${pname}: colorscheme style variants"
  [ "standard" "nord" ]
  schemeVariants
  lib.checkListOfEnum
  "${pname}: window control buttons variants"
  [ "normal" "alt" "all" ]
  altVariants
  lib.checkListOfEnum
  "${pname}: activities icon variants"
  [
    "standard"
    "apple"
    "simple"
    "gnome"
    "ubuntu"
    "tux"
    "arch"
    "manjaro"
    "fedora"
    "debian"
    "void"
    "opensuse"
    "popos"
    "mxlinux"
    "zorin"
    "budgie"
    "gentoo"
    "kali"
  ]
  (single iconVariant)
  lib.checkListOfEnum
  "${pname}: panel opacity"
  [ "default" "30" "45" "60" "75" ]
  (single panelOpacity)
  lib.checkListOfEnum
  "${pname}: panel size"
  [ "default" "smaller" "bigger" ]
  (single panelSize)

  stdenv.mkDerivation
  {
    pname = "mactahoe-gtk-theme";
    version = "2025-08-22";

    src = fetchFromGitHub {
      owner = "vinceliuice";
      repo = "MacTahoe-gtk-theme";
      rev = "2025-08-22";
      hash = "sha256-gyD16t8xA0yLyyNTH1zyA3ee/VjmkXFJErvZuSkPVnk=";
    };

    nativeBuildInputs = [
      dialog
      glib
      jdupes
      libxml2
      sassc
      util-linux
    ];

    buildInputs = [
      gnome-themes-extra
    ];

    postPatch = ''
      find -name "*.sh" -print0 | while IFS= read -r -d ''' file; do
        patchShebangs "$file"
      done

      # Do not provide sudo, not needed in Nix build
      substituteInPlace libs/lib-core.sh --replace-fail '$(which sudo)' false

      # Provides a dummy home directory
      substituteInPlace libs/lib-core.sh --replace-fail 'MY_HOME=$(getent passwd "''${MY_USERNAME}" | cut -d: -f6)' 'MY_HOME=/tmp'
    '';

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/themes

      ./install.sh \
        ${toString (map (x: "--alt " + x) altVariants)} \
        ${toString (map (x: "--color " + x) colorVariants)} \
        ${toString (map (x: "--opacity " + x) opacityVariants)} \
        ${toString (map (x: "--theme " + x) themeVariants)} \
        ${toString (map (x: "--scheme " + x) schemeVariants)} \
        ${lib.optionalString roundedMaxWindow "--roundedmaxwindow"} \
        ${lib.optionalString darkerColor "--darkercolor"} \
        ${lib.optionalString blur "--blur"} \
        ${lib.optionalString (iconVariant != null) ("--gnome-shell -i " + iconVariant)} \
        ${lib.optionalString (panelSize != null) ("--gnome-shell -panelheight " + panelSize)} \
        ${lib.optionalString (panelOpacity != null) ("--gnome-shell -panelopacity " + panelOpacity)} \
        --dest $out/share/themes

      jdupes --quiet --link-soft --recurse $out/share

      runHook postInstall
    '';

    meta = {
      description = "macOS Tahoe like theme for Linux GTK desktops";
      homepage = "https://github.com/vinceliuice/MacTahoe-gtk-theme";
      license = lib.licenses.mit;
      platforms = lib.platforms.unix;
    };
  }
