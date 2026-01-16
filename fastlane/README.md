fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios simulator

```sh
[bundle exec] fastlane ios simulator
```

Run the app in iOS Simulator via Makefile

### ios archive

```sh
[bundle exec] fastlane ios archive
```

Archive the app for App Store (requires signing)

### ios upload

```sh
[bundle exec] fastlane ios upload
```

Upload to App Store (credentials required)

### ios devices

```sh
[bundle exec] fastlane ios devices
```

List available simulators

### ios bump

```sh
[bundle exec] fastlane ios bump
```

Bump version number - Usage: fastlane bump type:patch|minor|major|build

### ios bump_patch

```sh
[bundle exec] fastlane ios bump_patch
```

Bump patch version (1.0.0 -> 1.0.1)

### ios bump_minor

```sh
[bundle exec] fastlane ios bump_minor
```

Bump minor version (1.0.0 -> 1.1.0)

### ios bump_major

```sh
[bundle exec] fastlane ios bump_major
```

Bump major version (1.0.0 -> 2.0.0)

### ios bump_build

```sh
[bundle exec] fastlane ios bump_build
```

Bump build number only

### ios version

```sh
[bundle exec] fastlane ios version
```

Get current version and build number

### ios screenshots

```sh
[bundle exec] fastlane ios screenshots
```

Generate screenshots for App Store using fastlane snapshot

### ios screenshots_iphone

```sh
[bundle exec] fastlane ios screenshots_iphone
```

Capture screenshots for iPhone devices only

### ios screenshots_ipad

```sh
[bundle exec] fastlane ios screenshots_ipad
```

Capture screenshots for iPad devices only

### ios screenshots_all

```sh
[bundle exec] fastlane ios screenshots_all
```

Capture screenshots for all devices (iPhone and iPad)

### ios process_screenshots

```sh
[bundle exec] fastlane ios process_screenshots
```

Process screenshots for App Store Connect (resize iPhone, copy iPad)

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
