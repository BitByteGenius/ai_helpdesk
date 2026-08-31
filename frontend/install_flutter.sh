#!/bin/bash

set -e

FLUTTER_VERSION="3.35.2"

echo "Installing Flutter ${FLUTTER_VERSION}..."

git clone --depth 1 --branch ${FLUTTER_VERSION} https://github.com/flutter/flutter.git "$HOME/flutter"

export PATH="$HOME/flutter/bin:$PATH"

flutter --version
flutter config --no-analytics

cd frontend
flutter pub get
flutter build web --release
