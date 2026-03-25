# DailyJournal

A beautiful, private daily journaling app for iOS 17+ and iPadOS 17+.

## Overview

DailyJournal is a feature-rich journaling application that helps you capture your thoughts, track your moods, and maintain a daily writing habit. With Face ID/Touch ID protection, your journal entries remain completely private.

## Features

### Core Journaling
- **One Entry Per Day**: Focus on daily reflection with a dedicated entry for each day
- **Rich Text Editor**: Format your entries with bold, italic, and list formatting
- **Photo Attachments**: Add photos from your camera or photo library to entries
- **Writing Prompts**: Get inspired with daily writing prompts

### Mood Tracking
- **10 Mood Options**: Track your emotional state with emoji-based mood selection
- **Visual Mood Calendar**: See mood indicators on the calendar view
- **Mood Charts**: Analyze your mood patterns with weekly and monthly charts

### Analytics & Insights
- **Streak Tracking**: Track consecutive journaling days
- **Statistics Dashboard**: View total entries, current streak, and longest streak
- **Mood Distribution**: Visualize mood trends with Swift Charts

### Privacy & Security
- **Face ID / Touch ID**: Lock your journal with biometric authentication
- **Local Storage**: All data stored locally using SwiftData
- **No Cloud Sync**: Your entries never leave your device

### Additional Features
- **Calendar View**: Browse entries by date with mood-colored indicators
- **Search**: Find entries by text content
- **Export**: Export your journal as PDF or plain text
- **Dark Mode**: Full support for system dark mode
- **iPad Support**: Optimized for both iPhone and iPad

## Technical Details

### Architecture
- **SwiftUI**: Modern declarative UI framework
- **MVVM Pattern**: Clean separation of concerns
- **SwiftData**: Persistent local storage
- **Swift Charts**: Native chart rendering
- **LocalAuthentication**: Biometric security

### Requirements
- iOS 17.0+ / iPadOS 17.0+
- iPhone or iPad
- Face ID or Touch ID capable device (optional)

### Bundle Information
- **Bundle ID**: com.lopodragon.dailyjournal
- **Version**: 1.0.0
- **Price**: $4.99 USD (one-time purchase)

## Project Structure

```
DailyJournal/
├── DailyJournalApp.swift          # App entry point
├── ContentView.swift              # Root view with authentication
├── Models/
│   ├── JournalEntry.swift         # SwiftData model for entries
│   └── Mood.swift                 # Mood enum with colors
├── ViewModels/
│   ├── JournalViewModel.swift     # Main journal logic
│   └── AuthenticationViewModel.swift # Biometric auth
├── Views/
│   ├── HomeView.swift             # Main tab view
│   ├── EntryEditorView.swift     # Entry creation/editing
│   ├── CalendarView.swift        # Calendar with mood indicators
│   ├── SearchView.swift          # Search functionality
│   ├── StatisticsView.swift      # Charts and stats
│   ├── SettingsView.swift        # App settings
│   └── Components/
│       ├── MoodPickerView.swift  # Mood selection UI
│       ├── RichTextEditor.swift  # Text formatting
│       ├── StreakView.swift      # Streak display
│       └── PhotoPickerView.swift # Photo selection
├── Services/
│   ├── PromptService.swift       # Writing prompts
│   └── ExportService.swift       # PDF/Text export
└── Utilities/
    ├── StreakCalculator.swift    # Streak logic
    └── DateExtensions.swift      # Date helpers
```

## Building

1. Open `DailyJournal.xcodeproj` in Xcode 15+
2. Select your target device or simulator
3. Build and run (⌘R)

## Privacy

DailyJournal is designed with privacy as a top priority:
- All journal entries are stored locally on your device
- No analytics or tracking
- No internet connection required
- Optional biometric lock for added security
- Photos are stored with external storage attribute for efficiency

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Version History

See CHANGELOG.md for detailed version history.

## Support

For issues, questions, or feature requests, please visit the GitHub repository.

---

**DailyJournal** - Your thoughts, your privacy, your story.
