# Accessibility Features

The Tennis Elbow Treatment App is designed to be fully accessible for all users, including those who rely on assistive technologies like VoiceOver.

## VoiceOver Support

The app provides comprehensive VoiceOver support throughout all screens:

### Tab Navigation
- **Treatment Tab**: "Treatment Plan - View your daily treatment activities and exercises"
- **Schedule Tab**: "Schedule - View and manage scheduled activities by date"
- **Progress Tab**: "Progress - View your recovery progress and pain trends"
- **Settings Tab**: "Settings - Manage app settings and view information"

### Interactive Elements

All interactive elements include:
- **Accessibility Labels**: Clear, descriptive labels that identify the element
- **Accessibility Hints**: Context about what happens when you interact with the element
- **Accessibility Values**: Current values for dynamic content (progress percentages, pain levels, weights)

#### Examples:
- Completion toggles: "Completed" or "Not completed" with hints like "Double tap to mark as incomplete"
- Weight pickers: "Increase weight - Increases weight by 1 pound"
- Pain level selectors: "Pain level: Mild" with description hints
- Progress indicators: "Progress: 75 percent complete"

### Screen Headers

Section headers are marked with the `.isHeader` accessibility trait, making it easy to navigate between sections using VoiceOver's heading navigation.

### Visual Elements

Decorative images and icons are hidden from VoiceOver using `.accessibilityHidden(true)` to reduce noise and improve navigation efficiency. Only meaningful visual elements are exposed to assistive technologies.

### Charts and Graphs

Charts include descriptive accessibility labels that summarize the data:
- Pain history charts describe the range and average pain levels
- Progress indicators announce completion percentages
- Trend indicators describe whether pain is improving, stable, or worsening

### Grouped Elements

Related information is grouped together for efficient navigation:
- Activity details (name, duration, sets, reps) are combined into single accessibility elements
- Stat rows combine labels and values into meaningful phrases
- Tip cards combine icons, titles, and descriptions

## Dynamic Type Support

The app uses standard iOS text styles which automatically support Dynamic Type:
- `.title`, `.headline`, `.body`, `.caption`, etc.
- Users can adjust text size in iOS Settings > Accessibility > Display & Text Size

## Color Independence

The app does not rely solely on color to convey information:
- Completion status includes both color (green) and icons (checkmark)
- Pain levels include emojis, text descriptions, and numerical values
- Progress includes both visual indicators and percentage text

## Reduce Motion Support

SwiftUI's built-in animations respect the system's Reduce Motion accessibility setting automatically.

## Testing Accessibility

### VoiceOver Testing
1. Enable VoiceOver: Settings > Accessibility > VoiceOver
2. Navigate through the app using:
   - Swipe right/left to move between elements
   - Double-tap to activate buttons
   - Three-finger swipe to scroll
   - Rotor gesture to navigate by headings

### Accessibility Inspector (Xcode)
1. Open Xcode
2. Run the app in Simulator
3. Open Accessibility Inspector: Xcode > Open Developer Tool > Accessibility Inspector
4. Inspect elements for:
   - Proper labels and hints
   - Correct traits (Button, Header, etc.)
   - Appropriate grouping

## Accessibility Features by Screen

### Treatment Plan View
- Plan header with activity count
- Progress summary with percentage
- Session sections (Morning, Afternoon, Evening) with completion counts
- Individual activities with completion toggles
- Expandable activity details with instructions

### Schedule View
- Date picker with accessible date selection
- Activity list with completion status
- Time and duration information
- Activity detail sheets

### Progress View
- Overall completion circle with percentage
- Pain trend indicators
- Pain history chart with data summary
- Weight progress tracking
- Weekly completion progress bar
- Activity breakdown by type
- Recent completions list

### Settings View
- Notification toggle with enable/disable hints
- Time pickers for morning and evening reminders
- Treatment plan picker
- Clear data button with warning
- Navigation links to information screens

### Medical Sources View
- Categorized source lists
- External links with clear indication
- Research citations with accessibility-friendly formatting

## Continuous Improvement

We are committed to maintaining and improving accessibility. If you encounter any accessibility issues, please report them through GitHub Issues.

## Resources

- [Apple Human Interface Guidelines - Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility)
- [iOS VoiceOver User Guide](https://support.apple.com/guide/iphone/turn-on-and-practice-voiceover-iph3e2e415f/ios)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
