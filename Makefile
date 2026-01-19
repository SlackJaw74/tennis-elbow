PROJECT := TennisElbow/TennisElbow.xcodeproj
SCHEME := TennisElbow
DERIVED := build
DEVICE ?= iPhone 16e
IPAD_DEVICE ?= iPad Pro 13-inch (M5)
BUNDLE_ID := com.madhouse.TennisElbow
APP := $(DERIVED)/Build/Products/Debug-iphonesimulator/TennisElbow.app

.PHONY: sim-build sim-install sim-launch sim-run device-list clean archive open-xcode

.PHONY: ipad-build ipad-install ipad-launch ipad-run test test-unit test-ui screenshots screenshots-iphone screenshots-ipad process-screenshots
.PHONY: screenshots-all-languages screenshots-iphone-all-languages screenshots-ipad-all-languages screenshot-debug
.PHONY: version bump-patch bump-minor bump-major bump-build
.PHONY: lint lint-fix format format-check fix

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

test:
	xcodebuild test \
	  -project "$(PROJECT)" \
	  -scheme "$(SCHEME)" \
	  -sdk iphonesimulator \
	  -destination "platform=iOS Simulator,name=$(DEVICE)" \
	  -derivedDataPath "$(DERIVED)" \
	  -enableCodeCoverage YES

test-unit:
	xcodebuild test \
	  -project "$(PROJECT)" \
	  -scheme "$(SCHEME)" \
	  -sdk iphonesimulator \
	  -destination "platform=iOS Simulator,name=$(DEVICE)" \
	  -derivedDataPath "$(DERIVED)" \
	  -enableCodeCoverage YES \
	  -only-testing:TennisElbowTests

test-ui:
	xcodebuild test \
	  -project "$(PROJECT)" \
	  -scheme "$(SCHEME)" \
	  -sdk iphonesimulator \
	  -destination "platform=iOS Simulator,name=$(DEVICE)" \
	  -derivedDataPath "$(DERIVED)" \
	  -enableCodeCoverage YES \
	  -only-testing:TennisElbowUITests

# Use system fastlane (Homebrew) directly - bundler requires modern Ruby
screenshots:
	@echo "Capturing screenshots for all devices..."
	fastlane screenshots

screenshots-iphone:
	@echo "Capturing screenshots for iPhone devices only..."
	fastlane screenshots_iphone

screenshots-ipad:
	@echo "Capturing screenshots for iPad devices only..."
	fastlane screenshots_ipad

process-screenshots:
	@echo "Processing screenshots for App Store Connect..."
	fastlane process_screenshots

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

# Linting and Formatting
lint:
	@echo "Running SwiftLint..."
	cd TennisElbow && swiftlint lint

lint-fix:
	@echo "Running SwiftLint with auto-fix..."
	cd TennisElbow && swiftlint --fix

format:
	@echo "Running SwiftFormat..."
	cd TennisElbow && swiftformat .

format-check:
	@echo "Checking SwiftFormat compliance..."
	cd TennisElbow && swiftformat --lint .

fix: format lint-fix
	@echo "All auto-fixes applied."
