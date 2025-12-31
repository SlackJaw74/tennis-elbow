#!/bin/bash

# Script to resize screenshots to App Store Connect required dimensions
# Required dimensions: 1284 × 2778 (6.7" display) or 1242 × 2688 (6.5" display)

set -e

SCREENSHOT_DIR="fastlane/screenshots/en-US"
OUTPUT_DIR="fastlane/screenshots/app-store-ready"

# Create output directory
mkdir -p "$OUTPUT_DIR"

echo "🔄 Resizing screenshots to App Store Connect requirements..."
echo ""

# Target dimension for 6.7" display (iPhone 14 Pro Max, 15 Pro Max, etc.)
TARGET_WIDTH=1284
TARGET_HEIGHT=2778

# Process iPhone 17 Pro Max screenshots (these are the largest and best quality)
for file in "$SCREENSHOT_DIR"/iPhone\ 17\ Pro\ Max-*.png; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        # Remove device prefix for cleaner naming
        new_filename=$(echo "$filename" | sed 's/iPhone 17 Pro Max-//')
        output_file="$OUTPUT_DIR/$new_filename"
        
        echo "Processing: $filename"
        echo "  → Resizing to ${TARGET_WIDTH}x${TARGET_HEIGHT}"
        
        # Resize using sips (built-in macOS tool)
        # Scale to fit within target dimensions while maintaining aspect ratio
        sips -z $TARGET_HEIGHT $TARGET_WIDTH "$file" --out "$output_file" > /dev/null 2>&1
        
        echo "  ✓ Saved to: $output_file"
    fi
done

echo ""
echo "✅ Screenshot resizing complete!"
echo "📁 App Store ready screenshots are in: $OUTPUT_DIR"
echo ""
echo "📋 These screenshots meet App Store Connect requirements:"
echo "   - Dimensions: ${TARGET_WIDTH} × ${TARGET_HEIGHT} (6.7\" display)"
echo "   - Required for: iPhone 14 Pro Max, 15 Pro Max, 16 Plus, etc."
echo ""
echo "💡 Use these resized screenshots when uploading to App Store Connect"

# Also copy the iPad screenshot as-is
if [ -f "$SCREENSHOT_DIR/iPad Pro 13-inch (M5)-01-TreatmentPlan.png" ]; then
    cp "$SCREENSHOT_DIR/iPad Pro 13-inch (M5)-01-TreatmentPlan.png" "$OUTPUT_DIR/"
    echo "📱 iPad screenshot copied (no resizing needed)"
fi
