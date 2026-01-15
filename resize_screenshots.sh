#!/bin/bash

# Script to resize screenshots to App Store Connect required dimensions
# iPhone: 1284 × 2778 (6.7" display) or 1242 × 2688 (6.5" display)
# iPad: Original resolution is used (2048 × 2732 for 12.9", etc.)

set -e

SCREENSHOT_DIR="fastlane/screenshots/en-US"
OUTPUT_DIR="fastlane/screenshots/app-store-ready"

# Create output directory
mkdir -p "$OUTPUT_DIR"

echo "🔄 Processing screenshots for App Store Connect..."
echo ""

# Target dimension for 6.7" display (iPhone 14 Pro Max, 15 Pro Max, etc.)
IPHONE_TARGET_WIDTH=1284
IPHONE_TARGET_HEIGHT=2778

echo "--- iPhone Screenshots ---"
# Process iPhone 17 Pro Max screenshots (these are the largest and best quality)
for file in "$SCREENSHOT_DIR"/iPhone\ 17\ Pro\ Max-*.png; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        # Remove device prefix for cleaner naming
        new_filename=$(echo "$filename" | sed 's/iPhone 17 Pro Max-/iPhone-/')
        output_file="$OUTPUT_DIR/$new_filename"
        
        echo "Processing: $filename"
        echo "  → Resizing to ${IPHONE_TARGET_WIDTH}x${IPHONE_TARGET_HEIGHT}"
        
        # Resize using sips (built-in macOS tool)
        # Scale to fit within target dimensions while maintaining aspect ratio
        sips -z $IPHONE_TARGET_HEIGHT $IPHONE_TARGET_WIDTH "$file" --out "$output_file" > /dev/null 2>&1
        
        echo "  ✓ Saved to: $output_file"
    fi
done

echo ""
echo "--- iPad Screenshots ---"
# Copy all iPad screenshots as-is (App Store uses original resolution)
for file in "$SCREENSHOT_DIR"/iPad*.png; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        # Extract device model for better organization
        device_model=$(echo "$filename" | sed -n 's/\(iPad[^-]*\)-.*/\1/p')
        screenshot_name=$(echo "$filename" | sed 's/.*-\([0-9][0-9]-.*\.png\)/\1/')
        new_filename="${device_model}-${screenshot_name}"
        output_file="$OUTPUT_DIR/$new_filename"
        
        echo "Processing: $filename"
        echo "  → Copying original resolution (no resize needed)"
        
        cp "$file" "$output_file"
        
        echo "  ✓ Saved to: $output_file"
    fi
done

echo ""
echo "✅ Screenshot processing complete!"
echo "📁 App Store ready screenshots are in: $OUTPUT_DIR"
echo ""
echo "📋 Screenshot Summary:"
echo "   iPhone: ${IPHONE_TARGET_WIDTH} × ${IPHONE_TARGET_HEIGHT} (6.7\" display)"
echo "   iPad: Original resolution (device-specific sizes)"
echo ""
echo "💡 Use these processed screenshots when uploading to App Store Connect"
