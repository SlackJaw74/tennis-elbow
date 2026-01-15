PROJECT := TennisElbow/TennisElbow.xcodeproj
SCHEME := TennisElbow
DERIVED := build
DEVICE ?= iPhone 16e
IPAD_DEVICE ?= iPad Pro 13-inch (M5)
BUNDLE_ID := com.madhouse.TennisElbow
APP := $(DERIVED)/Build/Products/Debug-iphonesimulator/TennisElbow.app

.PHONY: sim-build sim-install sim-launch sim-run device-list clean archive open-xcode format
.PHONY: ipad-build ipad-install ipad-launch ipad-run screenshots screenshots-iphone screenshots-ipad

sim-build:
	open -a Simulator || true
	xcodebuild \
	  -project "$(PROJECT)" \
	  -scheme "$(SCHEME)" \
	  -configuration Debug \
	  -sdk iphonesimulator \
	  -destination "platform=iOS Simulator,name=$(DEVICE)" \
	  -derivedDataPath "$(DERIVED)" \
	  clean build
	@echo "Build complete: $(APP)"

sim-install:
	@test -d "$(APP)" || (echo "App bundle not found at $(APP). Run 'make sim-build' first." && exit 1)
	xcrun simctl install booted "$(APP)"

sim-launch:
	xcrun simctl launch booted $(BUNDLE_ID)

sim-run: sim-build sim-install sim-launch

ipad-build:
	open -a Simulator || true
	xcodebuild \
	  -project "$(PROJECT)" \
	  -scheme "$(SCHEME)" \
	  -configuration Debug \
	  -sdk iphonesimulator \
	  -destination "platform=iOS Simulator,name=$(IPAD_DEVICE)" \
	  -derivedDataPath "$(DERIVED)" \
	  clean build
	@echo "iPad build complete: $(APP)"

ipad-install:
	@test -d "$(APP)" || (echo "App bundle not found at $(APP). Run 'make ipad-build' first." && exit 1)
	xcrun simctl install booted "$(APP)"

ipad-launch:
	xcrun simctl launch booted $(BUNDLE_ID)

ipad-run: ipad-build ipad-install ipad-launch

screenshots:
	@echo "Capturing screenshots for all devices (iPhone and iPad)..."
	./capture_screenshots.sh all

screenshots-iphone:
	@echo "Capturing screenshots for iPhone devices only..."
	./capture_screenshots.sh iphone

screenshots-ipad:
	@echo "Capturing screenshots for iPad devices only..."
	./capture_screenshots.sh ipad

device-list:
	xcrun simctl list devices

clean:
	rm -rf "$(DERIVED)" archives

archive:
	mkdir -p archives
	xcodebuild \
	  -project "$(PROJECT)" \
	  -scheme "$(SCHEME)" \
	  -configuration Release \
	  -destination "generic/platform=iOS" \
	  -archivePath "archives/TennisElbow.xcarchive" \
	  -allowProvisioningUpdates \
	  clean archive
	@echo "Archive created at archives/TennisElbow.xcarchive"

open-xcode:
	open "$(PROJECT)"

format:
	@command -v swiftformat >/dev/null 2>&1 || { echo "Error: swiftformat not installed. Install with: brew install swiftformat"; exit 1; }
	cd TennisElbow && swiftformat .
