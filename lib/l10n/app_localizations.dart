import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Pamuk Desktop'**
  String get appTitle;

  /// The subtitle of the application
  ///
  /// In en, this message translates to:
  /// **'Android Adware Uninstallation Tool'**
  String get appSubtitle;

  /// Button text to connect to Android device
  ///
  /// In en, this message translates to:
  /// **'Connect to Device'**
  String get connectToDevice;

  /// Button text to disconnect from device
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// Status text when device is connected
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// Status text when connecting to device
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get connecting;

  /// Status text when device is disconnected
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnected;

  /// Generic error text
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Label for catalogue mode
  ///
  /// In en, this message translates to:
  /// **'Catalogue Mode'**
  String get catalogueMode;

  /// Label for hunter mode
  ///
  /// In en, this message translates to:
  /// **'Hunter Mode'**
  String get hunterMode;

  /// Label for app list mode
  ///
  /// In en, this message translates to:
  /// **'App List'**
  String get appListMode;

  /// Placeholder text for app search field
  ///
  /// In en, this message translates to:
  /// **'Search apps...'**
  String get searchApps;

  /// Button text to refresh app list
  ///
  /// In en, this message translates to:
  /// **'Refresh Apps'**
  String get refreshApps;

  /// Button text to uninstall app
  ///
  /// In en, this message translates to:
  /// **'Uninstall'**
  String get uninstall;

  /// Button text to backup app
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backup;

  /// Title for installed apps section
  ///
  /// In en, this message translates to:
  /// **'Installed Apps'**
  String get installedApps;

  /// Title for adware apps section
  ///
  /// In en, this message translates to:
  /// **'Adware Apps'**
  String get adwareApps;

  /// Label for currently running app
  ///
  /// In en, this message translates to:
  /// **'Current App'**
  String get currentApp;

  /// Label for app version
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Label for app installation date
  ///
  /// In en, this message translates to:
  /// **'Install Date'**
  String get installDate;

  /// Label for app update date
  ///
  /// In en, this message translates to:
  /// **'Update Date'**
  String get updateDate;

  /// Label for app package name
  ///
  /// In en, this message translates to:
  /// **'Package Name'**
  String get packageName;

  /// Error message when ADB is not found
  ///
  /// In en, this message translates to:
  /// **'ADB not found'**
  String get adbNotFound;

  /// Description for ADB not found error
  ///
  /// In en, this message translates to:
  /// **'Please install Android SDK platform tools and add ADB to your PATH'**
  String get adbNotFoundDescription;

  /// Error message when no Android device is connected
  ///
  /// In en, this message translates to:
  /// **'No device connected'**
  String get noDeviceConnected;

  /// Description for no device connected error
  ///
  /// In en, this message translates to:
  /// **'Please connect an Android device with USB debugging enabled'**
  String get noDeviceConnectedDescription;

  /// Error message when device is unauthorized
  ///
  /// In en, this message translates to:
  /// **'Device unauthorized'**
  String get deviceUnauthorized;

  /// Description for device unauthorized error
  ///
  /// In en, this message translates to:
  /// **'Please allow USB debugging on your Android device'**
  String get deviceUnauthorizedDescription;

  /// Loading message when fetching apps
  ///
  /// In en, this message translates to:
  /// **'Loading apps...'**
  String get loadingApps;

  /// Message when no apps are found
  ///
  /// In en, this message translates to:
  /// **'No apps found'**
  String get noAppsFound;

  /// Success message after uninstalling app
  ///
  /// In en, this message translates to:
  /// **'App uninstalled successfully'**
  String get uninstallSuccess;

  /// Error message when uninstall fails
  ///
  /// In en, this message translates to:
  /// **'Failed to uninstall app'**
  String get uninstallError;

  /// Success message for backup and uninstall
  ///
  /// In en, this message translates to:
  /// **'App backed up and uninstalled successfully'**
  String get backupSuccess;

  /// Error message for backup and uninstall
  ///
  /// In en, this message translates to:
  /// **'Failed to backup and uninstall app'**
  String get backupError;

  /// Title for backup location selection dialog
  ///
  /// In en, this message translates to:
  /// **'Select backup location'**
  String get selectBackupLocation;

  /// Description for hunter mode functionality
  ///
  /// In en, this message translates to:
  /// **'Hunter mode monitors the currently running app and checks if it\'s adware'**
  String get hunterModeDescription;

  /// Description for catalogue mode functionality
  ///
  /// In en, this message translates to:
  /// **'Catalogue mode shows all known adware apps from the catalogue'**
  String get catalogueModeDescription;

  /// Description for app list mode functionality
  ///
  /// In en, this message translates to:
  /// **'App list mode shows all installed apps on the device'**
  String get appListModeDescription;

  /// Settings menu label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Language setting label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Turkish language option
  ///
  /// In en, this message translates to:
  /// **'Turkish'**
  String get turkish;

  /// About menu option
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// About dialog description
  ///
  /// In en, this message translates to:
  /// **'Pamuk Desktop is a Flutter application for detecting and removing Android adware apps.'**
  String get aboutDescription;

  /// Device label
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get device;

  /// Restart ADB server option
  ///
  /// In en, this message translates to:
  /// **'Restart ADB Server'**
  String get restartAdbServer;

  /// Troubleshooting option
  ///
  /// In en, this message translates to:
  /// **'Troubleshooting'**
  String get troubleshooting;

  /// Troubleshooting dialog title
  ///
  /// In en, this message translates to:
  /// **'Connection Troubleshooting'**
  String get troubleshootingTitle;

  /// Troubleshooting dialog description
  ///
  /// In en, this message translates to:
  /// **'If you\'re having trouble connecting to your Android device, please check:'**
  String get troubleshootingDescription;

  /// ADB installation troubleshooting section
  ///
  /// In en, this message translates to:
  /// **'1. ADB Installation:'**
  String get adbInstallation;

  /// Install Android SDK instruction
  ///
  /// In en, this message translates to:
  /// **'   • Install Android SDK platform tools'**
  String get installAndroidSDK;

  /// Add ADB to PATH instruction
  ///
  /// In en, this message translates to:
  /// **'   • Add ADB to your system PATH'**
  String get addAdbToPath;

  /// Test ADB command instruction
  ///
  /// In en, this message translates to:
  /// **'   • Test with: adb devices'**
  String get testAdbDevices;

  /// Device settings troubleshooting section
  ///
  /// In en, this message translates to:
  /// **'2. Device Settings:'**
  String get deviceSettings;

  /// Enable developer options instruction
  ///
  /// In en, this message translates to:
  /// **'   • Enable Developer Options'**
  String get enableDeveloperOptions;

  /// Enable USB debugging instruction
  ///
  /// In en, this message translates to:
  /// **'   • Enable USB Debugging'**
  String get enableUsbDebugging;

  /// Set USB mode instruction
  ///
  /// In en, this message translates to:
  /// **'   • Set USB mode to File Transfer (MTP)'**
  String get setUsbMode;

  /// Connection troubleshooting section
  ///
  /// In en, this message translates to:
  /// **'3. Connection:'**
  String get connectionTroubleshooting;

  /// Use quality USB cable instruction
  ///
  /// In en, this message translates to:
  /// **'   • Use a good quality USB cable'**
  String get useQualityUSBCable;

  /// Try different USB ports instruction
  ///
  /// In en, this message translates to:
  /// **'   • Try different USB ports'**
  String get tryDifferentPorts;

  /// Accept USB debugging dialog instruction
  ///
  /// In en, this message translates to:
  /// **'   • Accept USB debugging dialog on device'**
  String get acceptUsbDialog;

  /// Permissions troubleshooting section
  ///
  /// In en, this message translates to:
  /// **'4. Permissions:'**
  String get permissions;

  /// Run as administrator instruction
  ///
  /// In en, this message translates to:
  /// **'   • Run this app as administrator (if needed)'**
  String get runAsAdmin;

  /// Check USB authorization instruction
  ///
  /// In en, this message translates to:
  /// **'   • Check USB debugging authorization'**
  String get checkUsbAuthorization;

  /// Close button text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Mode label
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get mode;

  /// Hunter mode active title
  ///
  /// In en, this message translates to:
  /// **'Hunter Mode Active'**
  String get hunterModeActive;

  /// Hunter mode monitoring description
  ///
  /// In en, this message translates to:
  /// **'Monitoring the current foreground app on your device.'**
  String get monitoringCurrentApp;

  /// How it works section title
  ///
  /// In en, this message translates to:
  /// **'How it works:'**
  String get howItWorks;

  /// Hunter mode step 1
  ///
  /// In en, this message translates to:
  /// **'1. Open any app on your Android device'**
  String get step1;

  /// Hunter mode step 2
  ///
  /// In en, this message translates to:
  /// **'2. The app will be detected and shown below'**
  String get step2;

  /// Hunter mode step 3
  ///
  /// In en, this message translates to:
  /// **'3. You can choose to uninstall suspicious apps immediately'**
  String get step3;

  /// Hunter mode step 4
  ///
  /// In en, this message translates to:
  /// **'4. Uninstalled apps are automatically added to the catalogue'**
  String get step4;

  /// Waiting for app detection message
  ///
  /// In en, this message translates to:
  /// **'Waiting for app to be detected...'**
  String get waitingForApp;

  /// Instruction to open any app
  ///
  /// In en, this message translates to:
  /// **'Open any app on your Android device'**
  String get openAnyApp;

  /// Uninstall app dialog title
  ///
  /// In en, this message translates to:
  /// **'Uninstall App'**
  String get uninstallApp;

  /// Confirm uninstall dialog message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to uninstall \"{appName}\"?'**
  String confirmUninstall(String appName);

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Uninstall now button text
  ///
  /// In en, this message translates to:
  /// **'Uninstall Now'**
  String get uninstallNow;

  /// Backup and uninstall button text
  ///
  /// In en, this message translates to:
  /// **'Backup & Uninstall'**
  String get backupAndUninstall;

  /// Scanning for adware progress message
  ///
  /// In en, this message translates to:
  /// **'Scanning for adware packages...'**
  String get scanningAdware;

  /// Message when no adware is found
  ///
  /// In en, this message translates to:
  /// **'Your device looks clean. No known adware packages were detected.'**
  String get deviceClean;

  /// Button to switch to hunter mode
  ///
  /// In en, this message translates to:
  /// **'Switch to Hunter Mode'**
  String get switchToHunterMode;

  /// Uninstall all button text
  ///
  /// In en, this message translates to:
  /// **'Uninstall All'**
  String get uninstallAll;

  /// Uninstall all adware dialog title
  ///
  /// In en, this message translates to:
  /// **'Uninstall All Adware'**
  String get uninstallAllAdware;

  /// Success message after uninstalling multiple packages
  ///
  /// In en, this message translates to:
  /// **'Uninstalled {count} packages'**
  String uninstalledPackages(int count);

  /// Loading message when fetching installed apps
  ///
  /// In en, this message translates to:
  /// **'Loading installed apps...'**
  String get loadingAppsMessage;

  /// Count of apps displayed
  ///
  /// In en, this message translates to:
  /// **'{count} apps'**
  String appsCount(int count);

  /// Message when search returns no results
  ///
  /// In en, this message translates to:
  /// **'No apps found'**
  String get noAppsFoundSearch;

  /// Suggestion when no search results
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search terms'**
  String get adjustSearchTerms;

  /// Suggestion when no apps are found
  ///
  /// In en, this message translates to:
  /// **'Try refreshing the app list'**
  String get tryRefreshing;

  /// Refresh button text
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// Details option in menu
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// App details dialog title
  ///
  /// In en, this message translates to:
  /// **'App Details'**
  String get appDetails;

  /// Confirm uninstall all dialog message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to uninstall all {count} adware apps?'**
  String confirmUninstallAll(int count);

  /// Message when no adware is detected
  ///
  /// In en, this message translates to:
  /// **'No adware found!'**
  String get noAdwareFound;

  /// Title when adware is detected
  ///
  /// In en, this message translates to:
  /// **'Adware Detected!'**
  String get adwareDetected;

  /// Message showing number of suspicious packages
  ///
  /// In en, this message translates to:
  /// **'{count} suspicious packages found'**
  String suspiciousPackagesFound(int count);

  /// Warning message for irreversible actions
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get thisActionCannotBeUndone;

  /// Success message after uninstalling an app
  ///
  /// In en, this message translates to:
  /// **'Successfully uninstalled {appName}'**
  String successfullyUninstalled(String appName);

  /// Error message when uninstall fails
  ///
  /// In en, this message translates to:
  /// **'Failed to uninstall {appName}'**
  String failedToUninstall(String appName);

  /// Message explaining backup and uninstall process
  ///
  /// In en, this message translates to:
  /// **'This will backup the APK file for \"{appName}\" and then uninstall it.\n\nThe APK will be saved to the apk_backups folder.'**
  String backupApkMessage(String appName);

  /// Success message after backup and uninstall
  ///
  /// In en, this message translates to:
  /// **'Successfully backed up and uninstalled {appName}'**
  String successfullyBackedUpAndUninstalled(String appName);

  /// Error message when backup and uninstall fails
  ///
  /// In en, this message translates to:
  /// **'Failed to backup and uninstall {appName}'**
  String failedToBackupAndUninstall(String appName);

  /// Text for unknown category or value
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// Label for package name in details
  ///
  /// In en, this message translates to:
  /// **'Package'**
  String get package;

  /// Label for installation date
  ///
  /// In en, this message translates to:
  /// **'Installed'**
  String get installed;

  /// Label for update date
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get updated;

  /// Text for suspicious category
  ///
  /// In en, this message translates to:
  /// **'SUSPICIOUS'**
  String get suspicious;

  /// Warning message for known suspicious app
  ///
  /// In en, this message translates to:
  /// **'Known {category} app!'**
  String knownSuspiciousApp(String category);

  /// Title for contribute dialog
  ///
  /// In en, this message translates to:
  /// **'Contribute to Repository'**
  String get contributeToRepository;

  /// Message when package is added to catalogue
  ///
  /// In en, this message translates to:
  /// **'Package {packageName} has been added to the catalogue under \'{category}\' category.'**
  String packageAddedToCatalogue(String packageName, String category);

  /// Message asking user to contribute to repository
  ///
  /// In en, this message translates to:
  /// **'Please consider opening an issue at github.com/gAtrium/pamuk to help include this package in the official repository.'**
  String get considerContributing;

  /// Button to open GitHub repository
  ///
  /// In en, this message translates to:
  /// **'Open GitHub'**
  String get openGitHub;

  /// Button to dismiss contribution dialog
  ///
  /// In en, this message translates to:
  /// **'Not Now'**
  String get notNow;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
