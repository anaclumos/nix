{
  lib,
  pkgs,
  inputs,
  ...
}:
let
  fontAliases = [
    "Helvetica"
    "Helvetica Neue"
    "Arial"
    "-apple-system"
    "BlinkMacSystemFont"
    "Ubuntu"
    "noto-sans"
    "malgun gothic"
    "Apple SD Gothic Neo"
    "AppleSDGothicNeo"
    "Noto Sans TC"
    "Noto Sans JP"
    "Noto Sans KR"
    "Noto Sans"
    "Roboto"
    "Tahoma"
    "맑은 고딕"
    "맑은고딕"
    "MalgunGothic"
    "돋움"
  ];
  generateFontAlias = font: ''
    <match target="pattern">
      <test qual="any" name="family">
        <string>${font}</string>
      </test>
      <edit name="family" mode="assign" binding="same">
        <string>Sunghyun Sans KR</string>
      </edit>
    </match>
  '';
in
{
  fonts = {
    packages = with pkgs; [
      inputs.sunghyun-sans.packages.x86_64-linux.sunghyun-sans-kr
      monaspace
      iosevka
      sarasa-gothic
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
    ];
    fontDir.enable = true;
    fontconfig = {
      defaultFonts = {
        sansSerif = [
          "Sunghyun Sans KR"
          "Noto Sans CJK KR"
        ];
        serif = [
          "Sunghyun Sans KR"
          "Noto Serif CJK KR"
        ];
        monospace = [
          "Sarasa Mono K"
          "Monaspace"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
      localConf = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
        <fontconfig>
          ${lib.concatMapStrings generateFontAlias fontAliases}
        </fontconfig>
      '';
    };
  };
}
