{
  lib,
  appimageTools,
  fetchurl,
  makeWrapper,
}:
let
  pname = "heaper";
  version = "16.16.23";

  src = fetchurl {
    url = "https://github.com/JanLunge/heaper-releases/releases/download/electron-v${version}/Heaper-${version}-x86_64.AppImage";
    hash = "sha256-tFIzigDPZh/zgSbE3WBkaH4kuf7QjxHWEXwtQJNI9ww=";
  };

  appimageContents = appimageTools.extractType2 {inherit pname version src;};
  wrapped = appimageTools.wrapType2 {inherit pname version src;};
in
  wrapped.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [makeWrapper];

    installPhase =
      (old.installPhase or "")
      + ''
        # Wrap with Electron Wayland/HiDPI flags
        wrapProgram $out/bin/${pname} \
          --add-flags "--ozone-platform-hint=auto" \
          --add-flags "--enable-features=WaylandWindowDecorations"

        # Desktop entry
        install -m 444 -D ${appimageContents}/heaper.desktop $out/share/applications/heaper.desktop
        substituteInPlace $out/share/applications/heaper.desktop \
          --replace-fail 'Exec=AppRun' 'Exec=${pname}'

        # Icons
        for size in 16 32 48 64 128 256 512 1024; do
          icon="${appimageContents}/usr/share/icons/hicolor/''${size}x''${size}/apps/heaper.png"
          if [ -f "$icon" ]; then
            install -m 444 -D "$icon" \
              "$out/share/icons/hicolor/''${size}x''${size}/apps/heaper.png"
          fi
        done
      '';

    meta = {
      description = "Heaper - productivity app";
      homepage = "https://heaper.de";
      license = lib.licenses.unfree;
      platforms = ["x86_64-linux"];
      mainProgram = "heaper";
    };
  })
