#!/bin/bash

set -e

FLUTTER_VERSION="3.35.2"

if [ ! -d "$HOME/flutter" ]; then
  echo "Installing Flutter ${FLUTTER_VERSION}..."
  git clone --depth 1 --branch ${FLUTTER_VERSION} https://github.com/flutter/flutter.git "$HOME/flutter"
fi

export PATH="$HOME/flutter/bin:$PATH"

flutter --version
flutter config --no-analytics

# Navigate to frontend directory if running from root
if [ -d "frontend" ]; then
  cd frontend
fi

flutter pub get
flutter build web --release
