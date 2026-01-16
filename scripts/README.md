# Scripts Directory

This directory contains build and automation scripts for the Tennis Elbow app.

## Version Bump Script

**File:** `version_bump.sh`

Automatically increments version numbers in the Xcode project file.

### Usage

```bash
./version_bump.sh [major|minor|patch|build]
```

### Examples

```bash
# Patch version bump (1.0.0 -> 1.0.1)
./version_bump.sh patch

# Minor version bump (1.0.0 -> 1.1.0)
./version_bump.sh minor

# Major version bump (1.0.0 -> 2.0.0)
./version_bump.sh major

# Build number only
./version_bump.sh build
```

### How It Works

1. Reads current version from `TennisElbow/TennisElbow.xcodeproj/project.pbxproj`
2. Calculates new version based on bump type
3. Updates all occurrences of `MARKETING_VERSION` and `CURRENT_PROJECT_VERSION`
4. Provides instructions for committing and tagging

### Integration

This script is integrated with:
- **Makefile**: `make bump-patch`, `make bump-minor`, `make bump-major`, `make bump-build`
- **fastlane**: `fastlane bump_patch`, `fastlane bump_minor`, `fastlane bump_major`, `fastlane bump_build`

### Requirements

- Bash shell
- sed command (available on macOS and Linux)
- Access to the project file

### Documentation

For comprehensive version management documentation, see [VERSION_MANAGEMENT.md](../VERSION_MANAGEMENT.md).
