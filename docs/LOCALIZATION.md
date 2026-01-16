# Localization Guide

This document describes the localization support in the Tennis Elbow Treatment app.

## Supported Languages

The app supports the following 10 languages, which represent the most widely used languages on the iOS App Store:

1. **English (en)** - Primary language
2. **Spanish (es)** - Fully translated
3. **French (fr)** - Template ready for translation
4. **German (de)** - Template ready for translation
5. **Japanese (ja)** - Template ready for translation
6. **Chinese Simplified (zh-Hans)** - Template ready for translation
7. **Portuguese (pt)** - Template ready for translation
8. **Italian (it)** - Template ready for translation
9. **Dutch (nl)** - Template ready for translation
10. **Korean (ko)** - Template ready for translation

## File Structure

Each language has its own `.lproj` directory containing localized strings:

```
TennisElbow/TennisElbow/
├── Base.lproj/
│   └── Localizable.strings
├── en.lproj/
│   └── Localizable.strings
├── es.lproj/
│   └── Localizable.strings (Spanish translation)
├── fr.lproj/
│   └── Localizable.strings (French - needs translation)
├── de.lproj/
│   └── Localizable.strings (German - needs translation)
├── ja.lproj/
│   └── Localizable.strings (Japanese - needs translation)
├── zh-Hans.lproj/
│   └── Localizable.strings (Chinese Simplified - needs translation)
├── pt.lproj/
│   └── Localizable.strings (Portuguese - needs translation)
├── it.lproj/
│   └── Localizable.strings (Italian - needs translation)
├── nl.lproj/
│   └── Localizable.strings (Dutch - needs translation)
└── ko.lproj/
    └── Localizable.strings (Korean - needs translation)
```

## Translation Status

- ✅ **English (en)**: Complete (base language)
- ✅ **Spanish (es)**: Complete
- ⚠️ **French (fr)**: Template only - needs professional translation
- ⚠️ **German (de)**: Template only - needs professional translation
- ⚠️ **Japanese (ja)**: Template only - needs professional translation
- ⚠️ **Chinese Simplified (zh-Hans)**: Template only - needs professional translation
- ⚠️ **Portuguese (pt)**: Template only - needs professional translation
- ⚠️ **Italian (it)**: Template only - needs professional translation
- ⚠️ **Dutch (nl)**: Template only - needs professional translation
- ⚠️ **Korean (ko)**: Template only - needs professional translation

## How to Add Translations

### For Professional Translators

1. Open the `Localizable.strings` file for your language in the appropriate `.lproj` folder
2. Translate only the text on the right side of the `=` sign
3. Keep all keys (left side of `=`) in English
4. Preserve special characters like `%d` for string formatting
5. Do NOT translate medical terminology without consulting a medical professional

### Example

```strings
// English (en.lproj/Localizable.strings)
"Medical Disclaimer" = "Medical Disclaimer";
"Treatment Plan" = "Treatment Plan";

// Spanish (es.lproj/Localizable.strings)
"Medical Disclaimer" = "Descargo de Responsabilidad Médica";
"Treatment Plan" = "Plan de Tratamiento";

// French (fr.lproj/Localizable.strings) - TO BE TRANSLATED
"Medical Disclaimer" = "Medical Disclaimer";  // ← Translate this
"Treatment Plan" = "Treatment Plan";  // ← Translate this
```

### Important Medical Translation Notes

⚠️ **Medical Disclaimer**: This app contains health-related information. All medical terms, symptoms, and treatment descriptions must be reviewed by a healthcare professional who is fluent in the target language before publication.

Key medical terms to verify:
- Tennis elbow / Lateral epicondylitis
- Pain levels and descriptions
- Exercise instructions
- Medical disclaimers and warnings

## Testing Localizations

### In Xcode Simulator

1. Open the iOS Simulator
2. Go to Settings → General → Language & Region
3. Select the language you want to test
4. Relaunch the Tennis Elbow app
5. Verify all strings are displayed correctly

### Using Screenshots

The app is configured to generate screenshots for all supported languages:

```bash
# Generate screenshots for all languages
cd fastlane
bundle exec fastlane screenshots

# Screenshots will be generated in:
# fastlane/screenshots/en-US/
# fastlane/screenshots/es-ES/
# fastlane/screenshots/fr-FR/
# (etc. for all languages)
```

## Screenshot Generation

The `Snapfile` is configured to generate screenshots for all 10 languages:

```ruby
languages([
  "en-US",
  "es-ES",
  "fr-FR",
  "de-DE",
  "ja-JP",
  "zh-Hans",
  "pt-PT",
  "it-IT",
  "nl-NL",
  "ko-KR"
])
```

## Processing Screenshots for App Store

To prepare screenshots for App Store Connect submission:

```bash
cd fastlane
bundle exec fastlane process_screenshots
```

This will create language-specific directories in `fastlane/screenshots/app-store-ready/` with properly sized screenshots for each language.

## Code Usage

All user-facing strings in the app use the localization extension:

```swift
// String+Localization.swift
extension String {
    func localized(comment: String = "") -> String {
        NSLocalizedString(self, comment: comment)
    }
}

// Usage in views
Text("Treatment Plan".localized())
```

## Adding New Strings

When adding new user-facing text to the app:

1. Add the string to **all** `Localizable.strings` files
2. Use the English text as both the key and default value
3. Update translated versions (es.lproj) immediately
4. Mark untranslated versions (fr, de, ja, etc.) for translation

Example:
```strings
// Add to all .lproj/Localizable.strings files
"New Feature Title" = "New Feature Title";  // en
"New Feature Title" = "Nuevo Título de Función";  // es
"New Feature Title" = "New Feature Title";  // fr (needs translation)
```

## Language Priority

iOS automatically selects the language based on the user's device settings:

1. If the user's preferred language is available → use that language
2. If not available → fall back to the development language (English)
3. If strings are missing → use the Base.lproj version

## Resources for Translators

- All strings are in plain text format (`.strings` files)
- Medical terms should maintain accuracy across languages
- Consider cultural appropriateness of examples
- Test on-device to ensure text fits in UI elements
- Verify right-to-left languages display correctly (if added in future)

## Future Language Support

To add support for additional languages:

1. Create new `.lproj` directory (e.g., `ru.lproj` for Russian)
2. Copy English `Localizable.strings` as template
3. Update the Xcode project's `knownRegions` in `project.pbxproj`
4. Add language code to `Snapfile` languages array
5. Add language to Fastfile's `process_screenshots` languages array
6. Translate all strings
7. Test thoroughly

## Contact

For translation questions or medical terminology clarification, please consult with:
- Healthcare professionals fluent in the target language
- iOS localization best practices: https://developer.apple.com/localization/
