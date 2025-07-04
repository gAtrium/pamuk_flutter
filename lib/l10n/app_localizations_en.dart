// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Pamuk Desktop';

  @override
  String get appSubtitle => 'Android Adware Uninstallation Tool';

  @override
  String get connectToDevice => 'Connect to Device';

  @override
  String get disconnect => 'Disconnect';

  @override
  String get connected => 'Connected';

  @override
  String get connecting => 'Connecting...';

  @override
  String get disconnected => 'Disconnected';

  @override
  String get error => 'Error';

  @override
  String get catalogueMode => 'Catalogue Mode';

  @override
  String get hunterMode => 'Hunter Mode';

  @override
  String get appListMode => 'App List';

  @override
  String get searchApps => 'Search apps...';

  @override
  String get refreshApps => 'Refresh Apps';

  @override
  String get uninstall => 'Uninstall';

  @override
  String get backup => 'Backup';

  @override
  String get installedApps => 'Installed Apps';

  @override
  String get adwareApps => 'Adware Apps';

  @override
  String get currentApp => 'Current App';

  @override
  String get version => 'Version';

  @override
  String get installDate => 'Install Date';

  @override
  String get updateDate => 'Update Date';

  @override
  String get packageName => 'Package Name';

  @override
  String get adbNotFound => 'ADB not found';

  @override
  String get adbNotFoundDescription =>
      'Please install Android SDK platform tools and add ADB to your PATH';

  @override
  String get noDeviceConnected => 'No device connected';

  @override
  String get noDeviceConnectedDescription =>
      'Please connect an Android device with USB debugging enabled';

  @override
  String get deviceUnauthorized => 'Device unauthorized';

  @override
  String get deviceUnauthorizedDescription =>
      'Please allow USB debugging on your Android device';

  @override
  String get loadingApps => 'Loading apps...';

  @override
  String get noAppsFound => 'No apps found';

  @override
  String get uninstallSuccess => 'App uninstalled successfully';

  @override
  String get uninstallError => 'Failed to uninstall app';

  @override
  String get backupSuccess => 'App backed up and uninstalled successfully';

  @override
  String get backupError => 'Failed to backup and uninstall app';

  @override
  String get selectBackupLocation => 'Select backup location';

  @override
  String get hunterModeDescription =>
      'Hunter mode monitors the currently running app and checks if it\'s adware';

  @override
  String get catalogueModeDescription =>
      'Catalogue mode shows all known adware apps from the catalogue';

  @override
  String get appListModeDescription =>
      'App list mode shows all installed apps on the device';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get turkish => 'Turkish';

  @override
  String get about => 'About';

  @override
  String get aboutDescription =>
      'Pamuk Desktop is a Flutter application for detecting and removing Android adware apps.';

  @override
  String get device => 'Device';

  @override
  String get restartAdbServer => 'Restart ADB Server';

  @override
  String get troubleshooting => 'Troubleshooting';

  @override
  String get troubleshootingTitle => 'Connection Troubleshooting';

  @override
  String get troubleshootingDescription =>
      'If you\'re having trouble connecting to your Android device, please check:';

  @override
  String get adbInstallation => '1. ADB Installation:';

  @override
  String get installAndroidSDK => '   • Install Android SDK platform tools';

  @override
  String get addAdbToPath => '   • Add ADB to your system PATH';

  @override
  String get testAdbDevices => '   • Test with: adb devices';

  @override
  String get deviceSettings => '2. Device Settings:';

  @override
  String get enableDeveloperOptions => '   • Enable Developer Options';

  @override
  String get enableUsbDebugging => '   • Enable USB Debugging';

  @override
  String get setUsbMode => '   • Set USB mode to File Transfer (MTP)';

  @override
  String get connectionTroubleshooting => '3. Connection:';

  @override
  String get useQualityUSBCable => '   • Use a good quality USB cable';

  @override
  String get tryDifferentPorts => '   • Try different USB ports';

  @override
  String get acceptUsbDialog => '   • Accept USB debugging dialog on device';

  @override
  String get permissions => '4. Permissions:';

  @override
  String get runAsAdmin => '   • Run this app as administrator (if needed)';

  @override
  String get checkUsbAuthorization => '   • Check USB debugging authorization';

  @override
  String get close => 'Close';

  @override
  String get mode => 'Mode';

  @override
  String get hunterModeActive => 'Hunter Mode Active';

  @override
  String get monitoringCurrentApp =>
      'Monitoring the current foreground app on your device.';

  @override
  String get howItWorks => 'How it works:';

  @override
  String get step1 => '1. Open any app on your Android device';

  @override
  String get step2 => '2. The app will be detected and shown below';

  @override
  String get step3 =>
      '3. You can choose to uninstall suspicious apps immediately';

  @override
  String get step4 =>
      '4. Uninstalled apps are automatically added to the catalogue';

  @override
  String get waitingForApp => 'Waiting for app to be detected...';

  @override
  String get openAnyApp => 'Open any app on your Android device';

  @override
  String get uninstallApp => 'Uninstall App';

  @override
  String confirmUninstall(String appName) {
    return 'Are you sure you want to uninstall \"$appName\"?';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get uninstallNow => 'Uninstall Now';

  @override
  String get backupAndUninstall => 'Backup & Uninstall';

  @override
  String get scanningAdware => 'Scanning for adware packages...';

  @override
  String get deviceClean =>
      'Your device looks clean. No known adware packages were detected.';

  @override
  String get switchToHunterMode => 'Switch to Hunter Mode';

  @override
  String get uninstallAll => 'Uninstall All';

  @override
  String get uninstallAllAdware => 'Uninstall All Adware';

  @override
  String uninstalledPackages(int count) {
    return 'Uninstalled $count packages';
  }

  @override
  String get loadingAppsMessage => 'Loading installed apps...';

  @override
  String appsCount(int count) {
    return '$count apps';
  }

  @override
  String get noAppsFoundSearch => 'No apps found';

  @override
  String get adjustSearchTerms => 'Try adjusting your search terms';

  @override
  String get tryRefreshing => 'Try refreshing the app list';

  @override
  String get refresh => 'Refresh';

  @override
  String get details => 'Details';

  @override
  String get appDetails => 'App Details';

  @override
  String confirmUninstallAll(int count) {
    return 'Are you sure you want to uninstall all $count adware apps?';
  }

  @override
  String get noAdwareFound => 'No adware found!';

  @override
  String get adwareDetected => 'Adware Detected!';

  @override
  String suspiciousPackagesFound(int count) {
    return '$count suspicious packages found';
  }

  @override
  String get thisActionCannotBeUndone => 'This action cannot be undone.';

  @override
  String successfullyUninstalled(String appName) {
    return 'Successfully uninstalled $appName';
  }

  @override
  String failedToUninstall(String appName) {
    return 'Failed to uninstall $appName';
  }

  @override
  String backupApkMessage(String appName) {
    return 'This will backup the APK file for \"$appName\" and then uninstall it.\n\nThe APK will be saved to the apk_backups folder.';
  }

  @override
  String successfullyBackedUpAndUninstalled(String appName) {
    return 'Successfully backed up and uninstalled $appName';
  }

  @override
  String failedToBackupAndUninstall(String appName) {
    return 'Failed to backup and uninstall $appName';
  }

  @override
  String get unknown => 'Unknown';

  @override
  String get package => 'Package';

  @override
  String get installed => 'Installed';

  @override
  String get updated => 'Updated';

  @override
  String get suspicious => 'SUSPICIOUS';

  @override
  String knownSuspiciousApp(String category) {
    return 'Known $category app!';
  }

  @override
  String get contributeToRepository => 'Contribute to Repository';

  @override
  String packageAddedToCatalogue(String packageName, String category) {
    return 'Package $packageName has been added to the catalogue under \'$category\' category.';
  }

  @override
  String get considerContributing =>
      'Please consider opening an issue at github.com/gAtrium/pamuk to help include this package in the official repository.';

  @override
  String get openGitHub => 'Open GitHub';

  @override
  String get notNow => 'Not Now';
}
