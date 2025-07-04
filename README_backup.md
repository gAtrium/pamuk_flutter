# Pamuk Desktop

A modern Flutter desktop application for Android adware uninstallation, ported from the original [pamuk CLI tool](https://github.com/gAtrium/pamuk).

![Pamuk Desktop](pamuk.svg)

## Features

### 🖥️ Modern Desktop Interface
- Clean, intuitive Flutter-based UI
- Real-time device connection status
- Multi-mode operation with easy switching

### 🌍 Multi-language Support
- **English** and **Turkish** localization
- Runtime language switching
- All UI elements fully localized

### 🔍 Three Operation Modes

#### 1. Catalogue Mode
- Scan device for known adware packages
- Automatic detection based on curated catalogue
- Bulk uninstall options
- Visual indicators for threat levels

#### 2. Hunter Mode
- Real-time monitoring of foreground applications
- Instant detection and removal capabilities
- Automatic catalogue contribution
- GitHub integration for community reporting

#### 3. App List
- Browse all installed applications
- Search and filter functionality
- Detailed app information (version, install date, etc.)
- Individual app management

### 💾 Advanced Features
- **Backup & Uninstall**: Save APK files before removal
- **Real-time Detection**: Live monitoring of running apps
- **Community Contribution**: Easy reporting of new adware to GitHub
- **Catalogue Management**: Automatic updates to threat database

## Installation

### Download Pre-built Binaries

Download the latest release from [GitHub Releases](https://github.com/YOUR_USERNAME/pamuk-desktop/releases):

#### Windows
1. Download `pamuk-desktop-windows-x64.zip`
2. Extract to your desired location
3. Install Android SDK Platform Tools:
   - Download from: https://developer.android.com/studio/releases/platform-tools
   - Add ADB to your system PATH
4. Run `pamuk_desktop.exe`

#### Linux
1. Download `pamuk-desktop-linux-x64.zip`
2. Extract to your desired location
3. Make executable: `chmod +x pamuk_desktop`
4. Install Android SDK Platform Tools:
   ```bash
   # Ubuntu/Debian
   sudo apt install android-tools-adb
   
   # Arch Linux
   sudo pacman -S android-tools
   ```
5. Run `./pamuk_desktop`

## Requirements

- Flutter SDK (3.8.1 or higher)
- ADB (Android Debug Bridge) installed and added to PATH
- Android device with USB debugging enabled

## Installation

1. Clone or download this repository
2. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```
3. Ensure ADB is installed and accessible from command line
4. Connect your Android device with USB debugging enabled

## Usage

### Running the Application

```bash
flutter run -d linux    # For Linux
flutter run -d windows  # For Windows
flutter run -d macos    # For macOS
```

### Using the Application

1. **Connect Device**: Click the "Connect" button to connect to your Android device
2. **Choose Mode**:
   - **Catalogue Mode**: Automatically scans for known adware packages
   - **Hunter Mode**: Monitor apps in real-time as you open them on your device
   - **App List**: Browse all installed apps with search and filtering

### Modes Explained

#### Catalogue Mode
- Scans your device against a database of known adware packages
- Shows all detected suspicious apps with category labels
- Allows bulk uninstallation of all detected adware
- If no adware is found, offers to switch to Hunter Mode

#### Hunter Mode
- Monitors the current foreground app on your Android device in real-time
- Shows app details and warns if the app is in the adware catalogue
- Allows immediate uninstallation of suspicious apps
- Automatically adds uninstalled apps to the catalogue for future reference

#### App List Mode
- Shows all user-installed apps sorted by installation date
- Search functionality to find specific apps
- Detailed app information including version and install dates
- Individual app management (view details, uninstall, backup & uninstall)

### Features

- **Real-time Detection**: Hunter mode detects apps as you open them
- **APK Backup**: Option to backup APK files before uninstalling
- **Catalogue Management**: Automatically maintains a database of detected adware
- **Search & Filter**: Find specific apps quickly in the app list
- **Modern UI**: Clean, intuitive interface with Material Design 3

## Building

### Debug Build
```bash
flutter run -d linux
```

### Release Build
```bash
flutter build linux --release
flutter build windows --release
flutter build macos --release
```

## Project Structure

```
lib/
├── main.dart                 # Application entry point
├── models/                   # Data models
│   ├── app_info.dart        # App information model
│   └── catalogue.dart       # Catalogue model
├── services/                 # Business logic
│   ├── adb_service.dart     # ADB communication
│   ├── catalogue_service.dart # Catalogue management
│   └── pamuk_provider.dart  # Main application state
├── screens/                  # UI screens
│   └── main_screen.dart     # Main application screen
└── widgets/                  # UI components
    ├── connection_widget.dart # Device connection status
    ├── mode_selector.dart    # Mode selection buttons
    ├── catalogue_view.dart   # Catalogue mode UI
    ├── hunter_view.dart      # Hunter mode UI
    └── app_list_view.dart    # App list mode UI
```

## Contributing

This project is based on the original CLI Pamuk tool. To contribute:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project follows the same license as the original Pamuk CLI tool (MIT License).

## Troubleshooting

### ADB Not Found
- Ensure ADB is installed and added to your system PATH
- Test by running `adb devices` in terminal

### Device Not Detected
- Enable USB debugging on your Android device
- Check USB connection and accept debugging permission dialog
- Try different USB cable or port

### App Crashes
- Ensure Flutter SDK is properly installed
- Check that all dependencies are installed with `flutter pub get`
- Verify your device supports the built application

## Related Projects

- [Original Pamuk CLI Tool](../pamuk/) - Command-line version of this tool
