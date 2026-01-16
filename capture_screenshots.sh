#!/bin/bash

# Script to capture app screenshots for App Store submission
# Usage: ./capture_screenshots.sh [iphone|ipad|all]

set -e

PROJECT="TennisElbow/TennisElbow.xcodeproj"
SCHEME="TennisElbow"
OUTPUT_DIR="fastlane/screenshots"

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Default device type (all if not specified)
DEVICE_TYPE="${1:-all}"

# Array of iPhone devices for screenshots
IPHONE_DEVICES=(
  "iPhone 17 Pro Max"
  "iPhone 17 Pro"
  "iPhone 17"
  "iPhone 16e"
)

# Array of iPad devices for screenshots
IPAD_DEVICES=(
  "iPad Pro 13-inch (M5)"
  "iPad Pro 12.9-inch (6th generation)"
  "iPad Air 11-inch (M2)"
  "iPad (10th generation)"
)

# Function to run tests on a device
run_tests_on_device() {
  local device=$1
  local device_type=$2
  
  echo "📱 Running tests on: $device ($device_type)"
  
  # Run UI tests which will capture screenshots
  xcodebuild \
    -project "$PROJECT" \
    -scheme "$SCHEME" \
    -destination "platform=iOS Simulator,name=$device" \
    -derivedDataPath "./build" \
    test \
    2>&1 | grep -E "(Test Case|passed|failed|Screenshots)" || true
    
  echo "✓ Completed $device"
  echo ""
}

echo "🚀 Starting screenshot capture process..."
echo "📋 Device type: $DEVICE_TYPE"
echo ""

# Run tests based on device type
case "$DEVICE_TYPE" in
  iphone)
    echo "📱 Capturing screenshots for iPhone devices only..."
    echo ""
    for DEVICE in "${IPHONE_DEVICES[@]}"; do
      run_tests_on_device "$DEVICE" "iPhone"
    done
    ;;
  ipad)
    echo "📱 Capturing screenshots for iPad devices only..."
    echo ""
    for DEVICE in "${IPAD_DEVICES[@]}"; do
      run_tests_on_device "$DEVICE" "iPad"
    done
    ;;
  all)
    echo "📱 Capturing screenshots for all devices (iPhone and iPad)..."
    echo ""
    echo "--- iPhone Devices ---"
    for DEVICE in "${IPHONE_DEVICES[@]}"; do
      run_tests_on_device "$DEVICE" "iPhone"
    done
    echo ""
    echo "--- iPad Devices ---"
    for DEVICE in "${IPAD_DEVICES[@]}"; do
      run_tests_on_device "$DEVICE" "iPad"
    done
    ;;
  *)
    echo "❌ Invalid device type: $DEVICE_TYPE"
    echo "Usage: $0 [iphone|ipad|all]"
    exit 1
    ;;
esac

echo ""
echo "✅ Screenshot capture complete!"
echo "Screenshots are saved in: $OUTPUT_DIR"
echo ""
echo "📊 Screenshot Summary:"
echo "   - Run 'ls -l $OUTPUT_DIR' to see all captured screenshots"
echo "   - Screenshots are organized by device name"
