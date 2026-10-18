# Accountability Buddy

**Accountability Buddy** is a native iOS app built with Swift and SwiftUI to support daily reflection, personal planning, and consistent progress toward goals. It combines short check-ins, a record of past entries, progress tracking, and reminders in one place.

## Features

- **Onboarding:** An introduction for first-time users.
- **Daily check-ins:** Reflect on the day using guided questions and customizable prompts.
- **Planning:** Keep track of upcoming tasks, goals, and notes.
- **Reflection history:** Review saved entries and edit or delete past reflections.
- **Progress tracking:** See check-in totals and streak statistics.
- **Reminders:** Configure local notifications to encourage regular check-ins.
- **Settings:** Manage prompts, reminder preferences, and other app options.
- **Local storage:** Save reflections and preferences on the device without requiring an account.

## Technologies Used

| Technology | Purpose |
| --- | --- |
| Swift | Application logic and data models |
| SwiftUI | Native iOS user interface |
| MVVM | Organization of views and application state |
| Foundation / Codable | Data modeling and JSON serialization |
| UserDefaults | Local persistence of entries and preferences |
| UserNotifications | Local reminders and notification handling |

## App Structure

The application follows an MVVM-style structure:

- **Views:** Onboarding, Today, History, Progress, Settings, and reflection detail/edit screens.
- **View model:** `HomeViewModel` manages shared app state and user interactions.
- **Models:** Data types represent reflections and other app content.
- **Persistence:** Store components encode and decode local data.
- **Notifications:** `NotificationManager` handles reminder scheduling and notification permissions.

## Getting Started

### Requirements

- macOS with Xcode installed
- An iOS simulator or a compatible iPhone

### Run Locally

1. Clone this repository:
   ```bash
   git clone <repository-url>
   ```
2. Open the project's `.xcodeproj` or `.xcworkspace` file in Xcode.
3. Select an iPhone simulator or a connected iPhone.
4. If running on a physical device, configure your development team under **Signing & Capabilities**.
5. Build and run the app using **Command + R**.

## Data Storage

Accountability Buddy currently uses device-local storage. Reflection entries are encoded with `Codable` and stored using `UserDefaults`. Cloud synchronization and user accounts are not required for the current local-first experience.

## Future Improvements

- AI-assisted reflection and personalized follow-up questions
- Optional cloud backup and synchronization
- Account authentication
- Additional analytics and progress insights
- Expanded personalization and visual refinements

## Project Status

**In development.** The project currently focuses on a local-first iOS experience. AI-powered reflection and cloud synchronization are planned enhancements, not part of the current implementation.

## Author

**Masego Nontlantla Mirriam Mabe**  
GitHub: [MasegoMabe](https://github.com/MasegoMabe)