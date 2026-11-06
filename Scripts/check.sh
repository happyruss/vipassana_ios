#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
xcodebuild -scheme Vipassana -destination 'generic/platform=iOS' build
DEST="${1:-platform=iOS Simulator,name=iPhone 16}"
if xcodebuild -scheme Vipassana -destination "$DEST" -showBuildSettings >/dev/null 2>&1; then
  xcodebuild -scheme Vipassana -destination "$DEST" test
else
  echo "Simulator unavailable — skipping unit tests (release build already succeeded)."
fi
