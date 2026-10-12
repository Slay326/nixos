{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  mpv,
}: let
  version = "0.1.18";
  sources = {
    x86_64-linux = {
      file = "MovieBox_Linux_x64.tar.gz";
      hash = "sha256-QjDtn/+BVJih3pgCd/a1Hmn9W7sFhztPxOLQrMlY//I=";
    };
    aarch64-linux = {
      file = "MovieBox_Linux_arm64.tar.gz";
      hash = "sha256-7t5jOdW/s0uUGSV+pW/95TxXCE5M2ucZKCjuAN4QvVo=";
    };
  };
  source =
    sources.${stdenv.hostPlatform.system}
      or (throw "moviebox-tui: unsupported system ${stdenv.hostPlatform.system}");
in
  stdenv.mkDerivation {
    pname = "moviebox-tui";
    inherit version;

    src = fetchurl {
      url = "https://github.com/mesamirh/MovieBox-Tui/releases/download/v${version}/${source.file}";
      inherit (source) hash;
    };

    nativeBuildInputs = [makeWrapper];

    sourceRoot = ".";
    dontBuild = true;
    dontStrip = true;

    installPhase = ''
      runHook preInstall

      install -Dm755 moviebox-tui $out/bin/moviebox-tui
      wrapProgram $out/bin/moviebox-tui \
        --prefix PATH : ${lib.makeBinPath [mpv]}

      runHook postInstall
    '';

    meta = {
      description = "Terminal user interface for browsing and streaming movies and TV shows";
      homepage = "https://github.com/mesamirh/MovieBox-Tui";
      changelog = "https://github.com/mesamirh/MovieBox-Tui/releases/tag/v${version}";
      license = with lib.licenses; [
        mit
        asl20
      ];
      mainProgram = "moviebox-tui";
      platforms = builtins.attrNames sources;
      sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
    };
  }
