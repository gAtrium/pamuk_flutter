# Pamuk Desktop

A modern Flutter desktop application for Android adware uninstallation, ported from the original [pamuk CLI tool](https://github.com/gAtrium/pamuk).

![Pamuk Desktop](pamuk.svg)

## 📥 Download

### For End Users (Recommended)

**Download the latest stable release from [GitHub Releases](../../releases):**

- 🪟 **Windows**: Download `pamuk-desktop-windows-x64.zip`
- 🐧 **Linux**: Download `pamuk-desktop-linux-x64.zip`

These are official, tested releases that anyone can download and use.

### For Developers

- **Development builds**: Available as artifacts from CI builds (requires GitHub account)
- **Source code**: Clone this repository and build from source

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

### System Requirements

#### Windows
- Windows 10 or later (x64)
- Android SDK Platform Tools (ADB)

#### Linux
- Modern Linux distribution (x64)
- GTK 3.0 or later
- Android SDK Platform Tools (ADB)

### Setup Instructions

1. **Download** the appropriate release for your platform
2. **Extract** the ZIP file to your preferred location
3. **Install ADB** (Android Debug Bridge):
   - Download from [Android SDK Platform Tools](https://developer.android.com/studio/releases/platform-tools)
   - Add to your system PATH
4. **Enable USB Debugging** on your Android device:
   - Settings → Developer Options → USB Debugging
5. **Connect** your device and run the application

## Usage

1. **Launch** Pamuk Desktop
2. **Connect** your Android device via USB
3. **Select** your preferred operation mode:
   - **Catalogue**: Quick scan for known threats
   - **Hunter**: Real-time monitoring
   - **App List**: Browse all applications
4. **Follow** the on-screen instructions

## Building from Source

### Prerequisites
- Flutter SDK (≥3.32.5 with Dart ≥3.8.1)
- Platform-specific build tools:
  - **Windows**: Visual Studio 2022 or Build Tools
  - **Linux**: GTK development libraries

### Build Steps

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/pamuk-desktop.git
cd pamuk-desktop

# Install dependencies
flutter pub get

# Generate localizations
flutter gen-l10n

# Build for your platform
flutter build windows --release  # Windows
flutter build linux --release    # Linux
```

## Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Reporting New Adware

Use the **Hunter Mode** in-app reporting feature or submit an issue with:
- Package name
- App details
- Reason for classification

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Original [pamuk CLI tool](https://github.com/gAtrium/pamuk) by gAtrium
- Flutter team for the excellent desktop support
- Community contributors for adware reporting

## Support

- 🐛 **Bug Reports**: [GitHub Issues](../../issues)
- 💡 **Feature Requests**: [GitHub Discussions](../../discussions)
- 📖 **Documentation**: This README and in-app help

---

**⚠️ Important**: Always backup your data before removing applications. Pamuk Desktop provides backup functionality, but you should maintain your own backups of important data.