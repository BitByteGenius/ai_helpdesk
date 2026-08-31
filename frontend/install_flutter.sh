#!/bin/bash

set -e

FLUTTER_VERSION="3.47.2"

echo "Installing Flutter ${FLUTTER_VERSION}..."

if [ ! -d "$HOME/flutter" ]; then
  git clone --depth 1 --branch ${FLUTTER_VERSION} https://github.com/flutter/flutter.git "$HOME/flutter"
fi

export PATH="$HOME/flutter/bin:$PATH"

# Ensure flutter and dart binaries are accessible in PATH for any subsequent shell commands
if [ -w /usr/local/bin ]; then
  ln -sf "$HOME/flutter/bin/flutter" /usr/local/bin/flutter || true
  ln -sf "$HOME/flutter/bin/dart" /usr/local/bin/dart || true
fi

flutter --version
flutter config --no-analytics

echo "Fetching Flutter dependencies..."
flutter pub get
