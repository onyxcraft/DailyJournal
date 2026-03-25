# Changelog

All notable changes to DailyJournal will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-03-25

### Added
- Initial release of DailyJournal
- One journal entry per day with rich text formatting (bold, italic, lists)
- Mood tracking with 10 emoji-based mood options
- Photo attachments from camera or photo library
- Calendar view with mood-colored indicators
- Full-text search across all entries
- Streak tracking for consecutive journaling days
- Weekly and monthly mood distribution charts using Swift Charts
- Face ID / Touch ID biometric authentication
- Export entries as PDF or plain text files
- Daily writing prompts to inspire journaling
- Dark mode support
- iPad support with adaptive layouts
- SwiftData-based local storage
- MVVM architecture with clean separation of concerns

### Features Detail
- **Rich Text Editor**: Format text with toolbar controls for bold, italic, and lists
- **Mood Picker**: Select from 10 different moods with color-coded visual feedback
- **Calendar**: Interactive calendar grid showing entries with mood indicators
- **Statistics**: Dashboard with current streak, longest streak, total entries, and mood charts
- **Search**: Fast full-text search with entry preview
- **Export**: Share journal as PDF (formatted) or TXT (plain text)
- **Prompts**: 30 rotating daily writing prompts for inspiration
- **Privacy**: Optional Face ID/Touch ID lock, all data stored locally
- **Photos**: Attach photos with efficient external storage
- **Streak Tracking**: Automatic calculation of current and longest streaks

### Technical
- Minimum iOS 17.0 / iPadOS 17.0
- SwiftUI with MVVM architecture
- SwiftData for persistence
- LocalAuthentication framework for biometric security
- Swift Charts for data visualization
- PhotosUI for photo picking
- UIKit integration for camera and sharing

### Security
- All data stored locally using SwiftData
- No network requests or cloud synchronization
- Optional biometric authentication
- Photo data stored with external storage attribute

[1.0.0]: https://github.com/lopodragon/dailyjournal/releases/tag/v1.0.0
