# Arcanus Ledger

Flutter secure business ledger app.

## Supported Release Artifacts

This project is configured to produce only:

- Android APK: `build/app/outputs/flutter-apk/app-release.apk`
- macOS app zip: `arcanus-ledger-macos.zip`
- Linux app tarball: `arcanus-ledger-linux.tar.gz`
- Windows app zip: `arcanus-ledger-windows.zip`

The release workflow in `.github/workflows/build-release-artifacts.yml` uploads only those app artifacts when a `v*` tag is pushed.

## Local Builds

Use `./build.sh` to build the Android APK and the desktop artifact supported by the current host:

- macOS host: APK plus macOS zip
- Windows host: APK plus Windows zip
- Linux host: APK plus Linux tarball

Flutter requires macOS, Linux, and Windows desktop builds to run on their matching host platforms.
# arcanus-ledger
