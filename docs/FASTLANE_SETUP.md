# Fastlane Setup Guide

This guide explains how to install and use fastlane for the Tennis Elbow app, including the two supported installation methods.

## Installation Methods

The project supports two fastlane installation methods, each optimized for different use cases:

### Method 1: Homebrew (Recommended for Local Development)

**Install:**
```bash
brew install fastlane
```

**Advantages:**
- ✅ Simpler, one-command installation
- ✅ No Ruby version conflicts
- ✅ Automatic updates via Homebrew
- ✅ Works directly with Makefile targets
- ✅ No need to prefix commands with `bundle exec`

**Best for:**
- Local development on macOS
- Individual developers
- Quick setup and testing

**Verify installation:**
```bash
fastlane --version
which fastlane
# Should show /opt/homebrew/bin/fastlane or /usr/local/bin/fastlane
```

### Method 2: Bundler (Recommended for CI/CD)

**Install:**
```bash
cd fastlane
bundle install
```

**Advantages:**
- ✅ Consistent versions across team members and CI
- ✅ Locked dependencies in Gemfile.lock
- ✅ Better for reproducible builds
- ✅ Guaranteed same behavior across environments

**Considerations:**
- ⚠️ Requires `bundle exec` prefix when running commands directly
- ⚠️ Requires Ruby and Bundler to be installed
- ⚠️ May encounter Ruby version compatibility issues

**Best for:**
- CI/CD pipelines (GitHub Actions, Jenkins, etc.)
- Teams requiring consistent tooling versions
- Projects with strict dependency management

**Verify installation:**
```bash
cd fastlane
bundle exec fastlane --version
```

## Automatic Detection

The Makefile automatically detects which installation method you're using and uses the appropriate fastlane executable:

1. **First priority:** Homebrew fastlane (`/opt/homebrew/bin/fastlane` or `/usr/local/bin/fastlane`)
2. **Second priority:** Bundler fastlane (if `fastlane/Gemfile.lock` exists and `bundle` is available)
3. **Fallback:** Any `fastlane` in your PATH

This means you can use either installation method without modifying the Makefile or your workflow.

## Usage Examples

### Using Makefile (Recommended)

The Makefile provides convenient targets that work with both installation methods automatically:

```bash
# Screenshot generation
make screenshots                    # All devices, English only
make screenshots-all-languages      # All devices, all languages
make screenshots-iphone             # iPhone only, English
make screenshots-ipad               # iPad only, English
make process-screenshots            # Process for App Store

# These commands work identically regardless of installation method
```

### Using Fastlane Directly

If you need to run fastlane commands directly:

**With Homebrew:**
```bash
fastlane screenshots_all
fastlane screenshots_iphone
fastlane screenshots_ipad
fastlane process_screenshots
fastlane version
fastlane bump_patch
```

**With Bundler:**
```bash
cd fastlane
bundle exec fastlane screenshots_all
bundle exec fastlane screenshots_iphone
bundle exec fastlane screenshots_ipad
bundle exec fastlane process_screenshots
bundle exec fastlane version
bundle exec fastlane bump_patch
```

## Available Lanes

All fastlane lanes are defined in `fastlane/Fastfile`. See `fastlane/README.md` for the complete list.

Common lanes include:
- `screenshots_all` - Generate screenshots for all devices (English)
- `screenshots_all_languages` - Generate screenshots in all languages
- `screenshots_iphone` - iPhone screenshots only
- `screenshots_ipad` - iPad screenshots only
- `process_screenshots` - Process screenshots for App Store submission
- `version` - Display current version and build number
- `bump_patch`, `bump_minor`, `bump_major`, `bump_build` - Version management
- `simulator` - Run app in simulator
- `archive` - Create App Store archive
- `upload` - Upload to App Store Connect

## Troubleshooting

### Fastlane Not Found

If you get an error that fastlane is not available:

**For Homebrew users:**
```bash
brew install fastlane
```

**For Bundler users:**
```bash
cd fastlane
bundle install
```

### Ruby Version Issues (Bundler)

If you encounter Ruby version conflicts with bundler:

1. Consider switching to Homebrew installation (simpler)
2. Or use a Ruby version manager like rbenv or rvm:
   ```bash
   # Install rbenv
   brew install rbenv
   
   # Install required Ruby version
   rbenv install 3.2.0
   rbenv local 3.2.0
   
   # Install bundler and dependencies
   gem install bundler
   cd fastlane
   bundle install
   ```

### Makefile Not Detecting Bundler Installation

If you have bundler installed but the Makefile isn't detecting it:

1. Verify `Gemfile.lock` exists in the `fastlane/` directory
2. Verify `bundle` command is available: `which bundle`
3. Try running directly: `cd fastlane && bundle exec fastlane version`

### Mixed Installation

If you have both Homebrew and bundler installations, the Makefile will prefer Homebrew. This is intentional to avoid Ruby version conflicts. If you specifically want to use bundler in this scenario, run commands directly:

```bash
cd fastlane
bundle exec fastlane <lane_name>
```

## CI/CD Integration

For CI/CD environments (GitHub Actions, Jenkins, etc.), we recommend the bundler approach for consistency:

**GitHub Actions example:**
```yaml
- name: Install dependencies
  run: |
    cd fastlane
    bundle install

- name: Generate screenshots
  run: |
    cd fastlane
    bundle exec fastlane screenshots_all
```

**Or use the Makefile (which will detect bundler):**
```yaml
- name: Install dependencies
  run: |
    cd fastlane
    bundle install

- name: Generate screenshots
  run: make screenshots
```

## Recommendations

**For Individual Developers:**
- Use Homebrew installation
- Simple, fast, no extra setup
- Direct command usage without `bundle exec`

**For Teams:**
- Use Bundler installation
- Commit `Gemfile.lock` to version control
- Ensures everyone uses the same fastlane version
- Better for CI/CD reproducibility

**For Both:**
- Use Makefile targets when possible for convenience
- The Makefile handles the differences automatically
