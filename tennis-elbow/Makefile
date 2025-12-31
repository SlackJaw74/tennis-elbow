PROJECT := TennisElbow/TennisElbow.xcodeproj
SCHEME := TennisElbow
DERIVED := build
DEVICE ?= iPhone 16e
BUNDLE_ID := com.madhouse.TennisElbow
APP := $(DERIVED)/Build/Products/Debug-iphonesimulator/TennisElbow.app

.PHONY: sim-build sim-install sim-launch sim-run device-list clean archive open-xcode

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
