# Version Management Guide

This document describes the automatic version incrementing system for the Tennis Elbow app.

## Overview

The app uses semantic versioning with the format: `MAJOR.MINOR.PATCH (BUILD)`

- **MARKETING_VERSION** (CFBundleShortVersionString): User-facing version (e.g., 1.0.1)
- **CURRENT_PROJECT_VERSION** (CFBundleVersion): Build number (e.g., 2)

## Quick Start

### Check Current Version

```bash
# Using Make
make version

# Using fastlane
cd fastlane && bundle exec fastlane version

# Output example:
# Current version information:
#   Marketing Version: 1.0.0
#   Build Number: 1
```

### Bump Version

```bash
# Patch version (1.0.0 -> 1.0.1) - for bug fixes
make bump-patch

# Minor version (1.0.0 -> 1.1.0) - for new features
make bump-minor

# Major version (1.0.0 -> 2.0.0) - for breaking changes
make bump-major

# Build number only (keeps version same)
make bump-build
```

## Tools

### 1. Automatic Version Bumping (GitHub Actions)

**NEW**: Automatic version bumping on merge to main!

The repository includes a GitHub Actions workflow that automatically bumps the patch version whenever changes are merged to the `main` branch. This ensures every release has a unique version number.

**Features:**
- Automatically bumps patch version on merge to main
- Creates a git tag for the new version (e.g., `v1.0.1`)
- Commits the version bump with `[skip ci]` to avoid triggering another CI run
- Can be manually triggered with custom bump type (patch, minor, major, build)

**Manual Trigger:**
1. Go to Actions tab in GitHub
2. Select "Auto Version Bump" workflow
3. Click "Run workflow"
4. Select the bump type (patch, minor, major, or build)
5. Click "Run workflow"

**Configuration:**
The workflow is located at `.github/workflows/auto-version-bump.yml`

### 2. Shell Script (`scripts/version_bump.sh`)

The core version bumping script that directly modifies the Xcode project file.

**Usage:**
```bash
./scripts/version_bump.sh [major|minor|patch|build]
```

**Examples:**
```bash
# Patch bump: 1.0.0 -> 1.0.1
./scripts/version_bump.sh patch

# Minor bump: 1.0.0 -> 1.1.0
./scripts/version_bump.sh minor

# Major bump: 1.0.0 -> 2.0.0
./scripts/version_bump.sh major

# Build bump only
./scripts/version_bump.sh build
```

**What it does:**
- Reads current version from `TennisElbow/TennisElbow.xcodeproj/project.pbxproj`
- Increments version based on bump type
- Updates all occurrences in the project file
- Provides next steps for committing and tagging

### 3. Makefile Targets

Convenient shortcuts for version management.

**Available targets:**
```bash
make version      # Show current version
make bump-patch   # Bump patch version
make bump-minor   # Bump minor version
make bump-major   # Bump major version
make bump-build   # Bump build number only
```

### 4. Fastlane Lanes

For CI/CD integration and advanced workflows.

**Available lanes:**
```bash
# Show current version
fastlane version

# Bump specific version type
fastlane bump_patch
fastlane bump_minor
fastlane bump_major
fastlane bump_build

# Generic bump with type parameter
fastlane bump type:patch
fastlane bump type:minor
fastlane bump type:major
fastlane bump type:build
```

## Version Bumping Strategy

### When to Bump Patch (1.0.0 → 1.0.1)
- Bug fixes
- Performance improvements
- Minor UI tweaks
- Documentation updates

### When to Bump Minor (1.0.0 → 1.1.0)
- New features
- New functionality
- Significant improvements
- Backwards-compatible changes

### When to Bump Major (1.0.0 → 2.0.0)
- Breaking changes
- Major redesigns
- Significant architectural changes
- Removed features

### When to Bump Build Only
- CI/CD builds
- Internal testing builds
- No user-facing changes

## Workflow for Releases

### Standard Release Process

1. **Update version:**
   ```bash
   make bump-patch  # or bump-minor/bump-major
   ```

2. **Review changes:**
   ```bash
   git diff TennisElbow/TennisElbow.xcodeproj/project.pbxproj
   ```

3. **Commit version bump:**
   ```bash
   git add TennisElbow/TennisElbow.xcodeproj/project.pbxproj
   git commit -m "Bump version to 1.0.1 (2)"
   ```

4. **Tag the release:**
   ```bash
   git tag -a v1.0.1 -m "Release version 1.0.1"
   ```

5. **Push changes and tags:**
   ```bash
   git push origin main
   git push origin v1.0.1
   ```

6. **Create archive for App Store:**
   ```bash
   make archive
   # or
   cd fastlane && bundle exec fastlane archive
   ```

### CI/CD Integration

The version bumping can be integrated into CI/CD pipelines:

**GitHub Actions Example:**
```yaml
- name: Bump version
  run: make bump-patch

- name: Commit version bump
  run: |
    git config user.name "GitHub Actions"
    git config user.email "actions@github.com"
    git add TennisElbow/TennisElbow.xcodeproj/project.pbxproj
    git commit -m "chore: bump version [skip ci]"
    git push
```

## Manual Version Management

If you prefer to update versions manually:

1. Open `TennisElbow.xcodeproj` in Xcode
2. Select the project in the navigator
3. Select the "TennisElbow" target
4. Go to the "General" tab
5. Update:
   - **Version** (MARKETING_VERSION)
   - **Build** (CURRENT_PROJECT_VERSION)

Or edit the project file directly:
```bash
# Edit TennisElbow/TennisElbow.xcodeproj/project.pbxproj
# Find and update:
MARKETING_VERSION = 1.0.1;
CURRENT_PROJECT_VERSION = 2;
```

## Version History

To view version history:

```bash
# List all version tags
git tag -l "v*"

# Show tag details
git show v1.0.0

# View commit history with version bumps
git log --oneline --grep="Bump version"
```

## Troubleshooting

### Script not found error
```bash
# Make sure script is executable
chmod +x scripts/version_bump.sh
```

### Version not updating
- Ensure you're in the project root directory
- Check that `TennisElbow/TennisElbow.xcodeproj/project.pbxproj` exists
- Verify no merge conflicts in the project file

### fastlane lane not found
- Make sure you're in the `fastlane` directory when running fastlane commands
- Or use full path: `cd fastlane && bundle exec fastlane <lane>`

## Best Practices

1. **Always bump versions before releases** - Never release with the same version number
2. **Use semantic versioning** - Follow the MAJOR.MINOR.PATCH convention
3. **Tag releases** - Create git tags for each version (e.g., v1.0.1)
4. **Document changes** - Maintain a CHANGELOG.md file
5. **Automate in CI/CD** - Integrate version bumping into your build pipeline
6. **Test before bumping** - Ensure all tests pass before incrementing version
7. **Commit version bumps separately** - Keep version bump commits clean and focused

## References

- [Semantic Versioning 2.0.0](https://semver.org/)
- [Apple's Version Numbers and Build Numbers](https://developer.apple.com/documentation/bundleresources/information_property_list/cfbundleshortversionstring)
- [fastlane Documentation](https://docs.fastlane.tools/)
