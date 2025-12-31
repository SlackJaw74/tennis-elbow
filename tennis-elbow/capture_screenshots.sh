#!/bin/bash

# Script to capture app screenshots for App Store submission

set -e

PROJECT="TennisElbow/TennisElbow.xcodeproj"
SCHEME="TennisElbow"
OUTPUT_DIR="fastlane/screenshots"

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Array of devices for screenshots
DEVICES=(
  "iPhone 17 Pro Max"
  "iPhone 17 Pro"
  "iPhone 17"
  "iPhone 16e"
)

echo "🚀 Starting screenshot capture process..."
echo ""

for DEVICE in "${DEVICES[@]}"; do
  echo "📱 Running tests on: $DEVICE"
  
  # Run UI tests which will capture screenshots
  xcodebuild \
    -project "$PROJECT" \
    -scheme "$SCHEME" \
    -destination "platform=iOS Simulator,name=$DEVICE" \
    -derivedDataPath "./build" \
    test \
    2>&1 | grep -E "(Test Case|passed|failed|Screenshots)" || true
    
  echo "✓ Completed $DEVICE"
  echo ""
done

echo "✅ Screenshot capture complete!"
echo "Screenshots are saved in: $OUTPUT_DIR"
