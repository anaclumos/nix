{
  bash,
  callPackage,
  lib,
  makeDesktopItem,
  pretendard,
  stdenv,
  symlinkJoin,
  wineWowPackages,
  winetricks,
  wmctrl,
  xdotool,
  inputs,
}:
let
  sources = callPackage "${inputs.kakaotalk}/_sources/generated.nix" { };

  fontPath = symlinkJoin {
    name = "kakaotalk-fonts";
    paths = [ pretendard ];
  };

  westernFonts = [
    "Arial"
    "Times New Roman"
    "Courier New"
    "Verdana"
    "Tahoma"
    "Georgia"
    "Trebuchet MS"
    "Comic Sans MS"
    "Impact"
    "Lucida Console"
    "Lucida Sans Unicode"
    "Palatino Linotype"
    "Segoe UI"
    "Segoe Print"
    "Segoe Script"
    "Calibri"
    "Cambria"
    "Candara"
    "Consolas"
    "Constantia"
    "Corbel"
  ];

  koreanFonts = [
    "Gulim"
    "Dotum"
    "Batang"
    "Gungsuh"
    "Malgun Gothic"
  ];

  quoteList = l: lib.concatMapStringsSep " " (f: ''"${f}"'') l;

  desktopItem = makeDesktopItem {
    name = "kakaotalk";
    exec = "kakaotalk %U";
    icon = "kakaotalk";
    desktopName = "KakaoTalk";
    genericName = "Instant Messenger";
    comment = "Messaging and video calling";
    categories = [
      "Network"
      "InstantMessaging"
    ];
    mimeTypes = [ "x-scheme-handler/kakaotalk" ];
    startupWMClass = "kakaotalk.exe";
  };
in
stdenv.mkDerivation {
  pname = "kakaotalk";
  version = "0.2.0";

  inherit (sources.kakaotalk-exe) src;
  dontUnpack = true;

  nativeBuildInputs = [
    wineWowPackages.stable
    winetricks
  ];

  propagatedBuildInputs = [
    xdotool
    wmctrl
  ];

  installPhase = ''
    runHook preInstall
    install -Dm644 ${sources.kakaotalk-icon.src} $out/share/icons/hicolor/scalable/apps/kakaotalk.svg
    install -Dm644 $src $out/share/kakaotalk/KakaoTalk_Setup.exe
    install -Dm755 ${inputs.kakaotalk}/wrapper.sh $out/bin/kakaotalk
    substituteInPlace $out/bin/kakaotalk \
      --replace-fail "@bash@" "${bash}" \
      --replace-fail "@wineBin@" "${wineWowPackages.stable}/bin" \
      --replace-fail "@wineLib@" "${wineWowPackages.stable}/lib" \
      --replace-fail "@winetricks@" "${winetricks}" \
      --replace-fail "@out@" "$out" \
      --replace-fail "@westernFonts@" '${quoteList westernFonts}' \
      --replace-fail "@koreanFonts@" '${quoteList koreanFonts}' \
      --replace-fail "@fontPath@" "${fontPath}/share/fonts"
    install -Dm644 ${desktopItem}/share/applications/kakaotalk.desktop $out/share/applications/kakaotalk.desktop
    runHook postInstall
  '';

  meta = with lib; {
    description = "KakaoTalk messenger";
    homepage = "https://www.kakaocorp.com/page/service/service/KakaoTalk";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "kakaotalk";
  };
}
