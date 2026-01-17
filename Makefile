PROJECT := TennisElbow/TennisElbow.xcodeproj
SCHEME := TennisElbow
DERIVED := build
DEVICE ?= iPhone 16e
IPAD_DEVICE ?= iPad Pro 13-inch (M5)
BUNDLE_ID := com.madhouse.TennisElbow
APP := $(DERIVED)/Build/Products/Debug-iphonesimulator/TennisElbow.app

# Detect operating system
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
    OS_IS_MACOS := 1
else
    OS_IS_MACOS := 0
endif

.PHONY: sim-build sim-install sim-launch sim-run device-list clean archive open-xcode format
.PHONY: ipad-build ipad-install ipad-launch ipad-run screenshots screenshots-iphone screenshots-ipad process-screenshots
.PHONY: version bump-patch bump-minor bump-major bump-build

sim-build:
ifeq ($(OS_IS_MACOS),0)
	@echo "Error: This build requires macOS and Xcode."
	@echo "Current OS: $(UNAME_S)"
	@echo "Please run this command on a macOS system with Xcode installed."
	@exit 1
endif
	@open -a Simulator 2>/dev/null || true
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
ifeq ($(OS_IS_MACOS),0)
	@echo "Error: This command requires macOS and Xcode."
	@echo "Current OS: $(UNAME_S)"
	@echo "Please run this command on a macOS system with Xcode installed."
	@exit 1
endif
	@test -d "$(APP)" || (echo "App bundle not found at $(APP). Run 'make sim-build' first." && exit 1)
	xcrun simctl install booted "$(APP)"

sim-launch:
ifeq ($(OS_IS_MACOS),0)
	@echo "Error: This command requires macOS and Xcode."
	@echo "Current OS: $(UNAME_S)"
	@echo "Please run this command on a macOS system with Xcode installed."
	@exit 1
endif
	xcrun simctl launch booted $(BUNDLE_ID)

sim-run: sim-build sim-install sim-launch

ipad-build:
ifeq ($(OS_IS_MACOS),0)
	@echo "Error: This build requires macOS and Xcode."
	@echo "Current OS: $(UNAME_S)"
	@echo "Please run this command on a macOS system with Xcode installed."
	@exit 1
endif
	@open -a Simulator 2>/dev/null || true
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
ifeq ($(OS_IS_MACOS),0)
	@echo "Error: This command requires macOS and Xcode."
	@echo "Current OS: $(UNAME_S)"
	@echo "Please run this command on a macOS system with Xcode installed."
	@exit 1
endif
	@test -d "$(APP)" || (echo "App bundle not found at $(APP). Run 'make ipad-build' first." && exit 1)
	xcrun simctl install booted "$(APP)"

ipad-launch:
ifeq ($(OS_IS_MACOS),0)
	@echo "Error: This command requires macOS and Xcode."
	@echo "Current OS: $(UNAME_S)"
	@echo "Please run this command on a macOS system with Xcode installed."
	@exit 1
endif
	xcrun simctl launch booted $(BUNDLE_ID)

ipad-run: ipad-build ipad-install ipad-launch

screenshots:
ifeq ($(OS_IS_MACOS),0)
	@echo "Error: This command requires macOS and Xcode."
	@echo "Current OS: $(UNAME_S)"
	@echo "Please run this command on a macOS system with Xcode installed."
	@exit 1
endif
	@echo "Capturing screenshots for all devices (iPhone and iPad)..."
	cd fastlane && bundle exec fastlane screenshots_all

screenshots-iphone:
ifeq ($(OS_IS_MACOS),0)
	@echo "Error: This command requires macOS and Xcode."
	@echo "Current OS: $(UNAME_S)"
	@echo "Please run this command on a macOS system with Xcode installed."
	@exit 1
endif
	@echo "Capturing screenshots for iPhone devices only..."
	cd fastlane && bundle exec fastlane screenshots_iphone

screenshots-ipad:
ifeq ($(OS_IS_MACOS),0)
	@echo "Error: This command requires macOS and Xcode."
	@echo "Current OS: $(UNAME_S)"
	@echo "Please run this command on a macOS system with Xcode installed."
	@exit 1
endif
	@echo "Capturing screenshots for iPad devices only..."
	cd fastlane && bundle exec fastlane screenshots_ipad

process-screenshots:
ifeq ($(OS_IS_MACOS),0)
	@echo "Error: This command requires macOS and Xcode."
	@echo "Current OS: $(UNAME_S)"
	@echo "Please run this command on a macOS system with Xcode installed."
	@exit 1
endif
	@echo "Processing screenshots for App Store Connect..."
	cd fastlane && bundle exec fastlane process_screenshots

device-list:
ifeq ($(OS_IS_MACOS),0)
	@echo "Error: This command requires macOS and Xcode."
	@echo "Current OS: $(UNAME_S)"
	@echo "Please run this command on a macOS system with Xcode installed."
	@exit 1
endif
	xcrun simctl list devices

clean:
	rm -rf "$(DERIVED)" archives

archive:
ifeq ($(OS_IS_MACOS),0)
	@echo "Error: This build requires macOS and Xcode."
	@echo "Current OS: $(UNAME_S)"
	@echo "Please run this command on a macOS system with Xcode installed."
	@exit 1
endif
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
ifeq ($(OS_IS_MACOS),0)
	@echo "Error: This command requires macOS and Xcode."
	@echo "Current OS: $(UNAME_S)"
	@echo "Please run this command on a macOS system with Xcode installed."
	@exit 1
endif
	open "$(PROJECT)"

format:
	@command -v swiftformat >/dev/null 2>&1 || { echo "Error: swiftformat not installed. Install with: brew install swiftformat"; exit 1; }
	cd TennisElbow && swiftformat .

# Version Management
version:
	@echo "Current version information:"
	@grep -m 1 "MARKETING_VERSION = " "$(PROJECT)/project.pbxproj" | sed 's/.*MARKETING_VERSION = \(.*\);/  Marketing Version: \1/'
	@grep -m 1 "CURRENT_PROJECT_VERSION = " "$(PROJECT)/project.pbxproj" | sed 's/.*CURRENT_PROJECT_VERSION = \(.*\);/  Build Number: \1/'

bump-patch:
	@bash scripts/version_bump.sh patch

bump-minor:
	@bash scripts/version_bump.sh minor

bump-major:
	@bash scripts/version_bump.sh major

bump-build:
	@bash scripts/version_bump.sh build

