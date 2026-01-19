PROJECT := TennisElbow/TennisElbow.xcodeproj
SCHEME := TennisElbow
DERIVED := build
DEVICE ?= iPhone 16e
IPAD_DEVICE ?= iPad Pro 13-inch (M5)
BUNDLE_ID := com.madhouse.TennisElbow
APP := $(DERIVED)/Build/Products/Debug-iphonesimulator/TennisElbow.app

FASTLANE_DIR := fastlane
# Detect fastlane installation method
# 1. Prefer Homebrew fastlane (simpler, avoids Ruby version conflicts)
# 2. Fall back to bundler fastlane (if Gemfile.lock exists and bundle is available)
# 3. Fall back to any fastlane in PATH
HOMEBREW_FASTLANE := $(shell command -v /opt/homebrew/bin/fastlane 2>/dev/null || command -v /usr/local/bin/fastlane 2>/dev/null)
BUNDLE_FASTLANE := $(shell [ -f "$(FASTLANE_DIR)/Gemfile.lock" ] && command -v bundle >/dev/null 2>&1 && echo "bundle exec fastlane")
FASTLANE := $(if $(HOMEBREW_FASTLANE),$(HOMEBREW_FASTLANE),$(if $(BUNDLE_FASTLANE),$(BUNDLE_FASTLANE),$(shell command -v fastlane)))

.PHONY: sim-build sim-install sim-launch sim-run device-list clean archive open-xcode format
.PHONY: ipad-build ipad-install ipad-launch ipad-run process-screenshots screenshot-debug
.PHONY: screenshots screenshots-all-languages screenshots-iphone screenshots-iphone-all-languages screenshots-ipad screenshots-ipad-all-languages
.PHONY: fastlane-run
.PHONY: version bump-patch bump-minor bump-major bump-build

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

fastlane-run:
	@set -e; \
	lane="$(LANE)"; \
	params="$(PARAMS)"; \
	if [ -z "$$lane" ]; then echo "Error: LANE not set"; exit 1; fi; \
	if [ -n "$(FASTLANE)" ]; then \
		echo "Using fastlane: $(FASTLANE)"; \
		if [ -n "$$params" ]; then \
			echo "Running lane: $$lane with params: $$params"; \
			cd "$(FASTLANE_DIR)" && $(FASTLANE) $$lane $$params; \
		else \
			echo "Running lane: $$lane"; \
			cd "$(FASTLANE_DIR)" && $(FASTLANE) $$lane; \
		fi; \
	else \
		echo "Error: fastlane not available."; \
		echo "Install with one of these methods:"; \
		echo "  1. Homebrew (recommended): brew install fastlane"; \
		echo "  2. Bundler: cd $(FASTLANE_DIR) && bundle install"; \
		exit 1; \
	fi

# Screenshot targets - English only by default, use *-all-languages for all locales
screenshots:
	@echo "Capturing screenshots for all devices (English only)..."
	@$(MAKE) fastlane-run LANE=screenshots_all

screenshots-all-languages:
	@echo "Capturing screenshots for all devices in ALL languages (this takes a while)..."
	@$(MAKE) fastlane-run LANE=screenshots_all_languages

screenshots-iphone:
	@echo "Capturing screenshots for iPhone devices only (English)..."
	@$(MAKE) fastlane-run LANE=screenshots_iphone

screenshots-iphone-all-languages:
	@echo "Capturing screenshots for iPhone devices in ALL languages..."
	@$(MAKE) fastlane-run LANE=screenshots_iphone PARAMS="all_languages:true"

screenshots-ipad:
	@echo "Capturing screenshots for iPad devices only (English)..."
	@$(MAKE) fastlane-run LANE=screenshots_ipad

screenshots-ipad-all-languages:
	@echo "Capturing screenshots for iPad devices in ALL languages..."
	@$(MAKE) fastlane-run LANE=screenshots_ipad PARAMS="all_languages:true"

# Quick single screenshot for debugging - bypasses fastlane
# Sets up the environment that fastlane's snapshot would normally create
screenshot-debug:
	@echo "Running single device screenshot test for debugging..."
	@mkdir -p screenshots/en-US
	@mkdir -p ~/Library/Caches/tools.fastlane/screenshots
	@echo "en-US" > ~/Library/Caches/tools.fastlane/language.txt
	@echo "en-US" > ~/Library/Caches/tools.fastlane/locale.txt
	@touch ~/Library/Caches/tools.fastlane/snapshot-launch_arguments.txt
	SIMULATOR_HOST_HOME=$(HOME) xcodebuild test \
	  -project "$(PROJECT)" \
	  -scheme "$(SCHEME)" \
	  -configuration Debug \
	  -sdk iphonesimulator \
	  -destination "platform=iOS Simulator,name=$(DEVICE)" \
	  -derivedDataPath "$(DERIVED)" \
	  -only-testing:TennisElbowUITests/TennisElbowUITests/testScreenshots \
	  2>&1 | tee screenshot-debug.log
	@echo ""
	@echo "=== Debug Complete ==="
	@echo "Log saved to: screenshot-debug.log"
	@echo "Screenshots saved to: ~/Library/Caches/tools.fastlane/screenshots/"
	@ls -la ~/Library/Caches/tools.fastlane/screenshots/ 2>/dev/null || echo "No screenshots found"
	@echo ""
	@echo "Copying screenshots to screenshots/en-US/..."
	@cp ~/Library/Caches/tools.fastlane/screenshots/*.png screenshots/en-US/ 2>/dev/null || echo "No PNG files to copy"
	@ls -la screenshots/en-US/

process-screenshots:
	@echo "Processing screenshots for App Store Connect..."
	@$(MAKE) fastlane-run LANE=process_screenshots

device-list:
	xcrun simctl list devices available

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

