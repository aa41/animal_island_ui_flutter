#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "[animal-island-ui-flutter] flutter pub get"
cd "$ROOT_DIR"
flutter pub get

echo "[animal-island-ui-flutter] flutter analyze"
flutter analyze

echo "[animal-island-ui-flutter] example/flutter pub get"
cd "$ROOT_DIR/example"
flutter pub get

echo "[animal-island-ui-flutter] example/flutter analyze"
flutter analyze

echo "[animal-island-ui-flutter] flutter test"
cd "$ROOT_DIR"
flutter test

echo "[animal-island-ui-flutter] example/flutter test"
cd "$ROOT_DIR/example"
flutter test

echo "[animal-island-ui-flutter] example/flutter build web"
flutter build web

echo "[animal-island-ui-flutter] done"
