#!/usr/bin/env bash
set -euo pipefail

APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ARCANUS_ROOT="$(cd "${APP_DIR}/.." && pwd)"
FLUTTER_BIN="${FLUTTER_BIN:-${ARCANUS_ROOT}/bin/flutter}"

export ARCANUS_VAULT_ROOT="${ARCANUS_VAULT_ROOT:-${ARCANUS_ROOT}/Arcanus Vault}"
export PATH="${ARCANUS_ROOT}/bin:${PATH}"

APP_NAME="${APP_NAME:-arcanus-ledger}"
DIST_DIR="${DIST_DIR:-dist}"
HOST_OS="$(uname -s)"
DATA_DIR="${DATA_DIR:-${APP_DIR}/Data}"

cd "${APP_DIR}"
mkdir -p "$DIST_DIR"
mkdir -p "${DATA_DIR}"

DATA_DIR_ABS="$(cd "${DATA_DIR}" && pwd)"
LIB_DIR_ABS="$(cd "${APP_DIR}/lib" && pwd)"

case "${DATA_DIR_ABS}" in
  "${LIB_DIR_ABS}"|"${LIB_DIR_ABS}"/*)
    echo "ERROR: Ledger data cannot be created under ${LIB_DIR_ABS}." >&2
    exit 1
    ;;
esac

mkdir -p \
  "${DATA_DIR}/database" \
  "${DATA_DIR}/backups" \
  "${DATA_DIR}/exports" \
  "${DATA_DIR}/attachments" \
  "${DATA_DIR}/temp/cached_pdfs" \
  "${DATA_DIR}/temp/reports" \
  "${DATA_DIR}/logs"

if [[ ! -f "${DATA_DIR}/.recordkeep_vault" ]]; then
  printf '{\n  "vaultVersion": 1,\n  "app": "RecordKeep",\n  "portable": true\n}\n' \
    > "${DATA_DIR}/.recordkeep_vault"
fi

default_targets="android"
case "$HOST_OS" in
  Darwin) default_targets="${default_targets},macos" ;;
  MINGW*|MSYS*|CYGWIN*) default_targets="${default_targets},windows" ;;
  Linux) default_targets="${default_targets},linux" ;;
esac

BUILD_TARGETS="${BUILD_TARGETS:-${default_targets}}"
IFS=' ' read -r -a requested_targets <<< "${BUILD_TARGETS//,/ }"

target_count=0
for target in "${requested_targets[@]}"; do
  case "$target" in
    android|macos|windows|linux)
      target_count=$((target_count + 1))
      ;;
    "")
      ;;
    *)
      echo "ERROR: Unsupported Flutter target '${target}'. Allowed targets: android, macos, windows, linux." >&2
      exit 1
      ;;
  esac
done

if [[ "$target_count" -eq 0 ]]; then
  echo "ERROR: No build targets requested. Allowed targets: android, macos, windows, linux." >&2
  exit 1
fi

if [[ ! -x "${FLUTTER_BIN}" ]]; then
  echo "ERROR: flutter not found at ${FLUTTER_BIN}" >&2
  echo "Place the portable Flutter runtime at ${ARCANUS_ROOT}/bin/flutter or set FLUTTER_BIN." >&2
  exit 1
fi

echo "Preparing Flutter dependencies..."
"${FLUTTER_BIN}" pub get

require_host() {
  local target="$1"
  local expected="$2"
  if [[ "$HOST_OS" != "$expected" ]]; then
    echo "ERROR: ${target} must be built on ${expected}; current host is ${HOST_OS}." >&2
    exit 1
  fi
}

build_android() {
  echo "Building Android APK..."
  "${FLUTTER_BIN}" build apk --release
  cp build/app/outputs/flutter-apk/app-release.apk "$DIST_DIR/${APP_NAME}-android.apk"
}

build_macos() {
  require_host "macOS" "Darwin"
  echo "Building macOS app..."
  "${FLUTTER_BIN}" config --enable-macos-desktop
  "${FLUTTER_BIN}" build macos --release

  shopt -s nullglob
  local macos_apps=(build/macos/Build/Products/Release/*.app)
  if [[ ${#macos_apps[@]} -eq 0 ]]; then
    echo "No macOS .app found in build/macos/Build/Products/Release" >&2
    exit 1
  fi
  ditto -c -k --keepParent "${macos_apps[0]}" "$DIST_DIR/${APP_NAME}-macos.zip"
}

build_windows() {
  case "$HOST_OS" in
    MINGW*|MSYS*|CYGWIN*) ;;
    *)
      echo "ERROR: Windows must be built on Windows; current host is ${HOST_OS}." >&2
      exit 1
      ;;
  esac

  echo "Building Windows app..."
  "${FLUTTER_BIN}" config --enable-windows-desktop
  "${FLUTTER_BIN}" build windows --release
  powershell.exe -NoProfile -Command \
    "Compress-Archive -Path 'build/windows/x64/runner/Release/*' -DestinationPath '${DIST_DIR}/${APP_NAME}-windows.zip' -Force"
}

build_linux() {
  require_host "Linux" "Linux"
  echo "Building Linux app..."
  "${FLUTTER_BIN}" config --enable-linux-desktop
  "${FLUTTER_BIN}" build linux --release
  tar -czf "$DIST_DIR/${APP_NAME}-linux.tar.gz" \
    -C build/linux/x64/release bundle
}

echo "Allowed build targets: android, macos, windows, linux"
echo "Requested build targets: ${requested_targets[*]}"

for target in "${requested_targets[@]}"; do
  case "$target" in
    android) build_android ;;
    macos) build_macos ;;
    windows) build_windows ;;
    linux) build_linux ;;
    "")
      ;;
    *)
      echo "ERROR: Unsupported Flutter target '${target}'. Allowed targets: android, macos, windows, linux." >&2
      exit 1
      ;;
  esac
done

echo "Allowed release artifacts are in $DIST_DIR:"
find "$DIST_DIR" -maxdepth 1 -type f \( -name "${APP_NAME}-android.apk" -o -name "${APP_NAME}-macos.zip" -o -name "${APP_NAME}-linux.tar.gz" -o -name "${APP_NAME}-windows.zip" \) -print
