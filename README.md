# ArvyaX - Calm Ambience App

A premium meditation and focus app with ambient sounds.

## 📱 Features
- **6 Ambiences** - Forest, Ocean, Night Sky, Mountain Stream, Rain Library, Desert Night
- **Search & Filter** - Find ambiences by name or tag (Focus/Calm/Sleep/Reset)
- **Session Player** - Timer, play/pause, seek bar, breathing animation
- **Mini Player** - Control playback from any screen
- **Journal** - Reflect on sessions with mood tracking
- **History** - View all past reflections

## 🏗️ Architecture
- **State Management**: BLoC pattern
- **Local Storage**: Hive for journal entries
- **Dependency Injection**: Get_it

## 📦 Packages Used
- flutter_bloc - State management
- hive_flutter - Local database
- equatable - State comparison
- get_it - Dependency injection
- uuid - Generate unique IDs

## 🚀 How to Run
bash
# Clone the repository
git clone https://github.com/BALA-DINISHA/arvya-ambience-app.git

# Go to project folder
cd arvya-ambience-app

# Get dependencies
flutter pub get

# Run the app
flutter run
