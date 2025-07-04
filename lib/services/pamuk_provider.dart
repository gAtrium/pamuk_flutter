import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/app_info.dart';
import '../models/catalogue.dart';
import '../services/adb_service.dart';
import '../services/catalogue_service.dart';

enum AppMode { catalogue, hunter, appList }

enum ConnectionStatus { disconnected, connecting, connected, error }

class PamukProvider extends ChangeNotifier {
  final AdbService _adbService = AdbService();
  final CatalogueService _catalogueService = CatalogueService();

  // State
  ConnectionStatus _connectionStatus = ConnectionStatus.disconnected;
  String? _connectedDevice;
  List<AppInfo> _installedApps = [];
  List<AppInfo> _filteredApps = [];
  Catalogue? _catalogue;
  AppMode _currentMode = AppMode.catalogue;
  String _searchQuery = '';
  String? _currentApp;
  Timer? _hunterTimer;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  ConnectionStatus get connectionStatus => _connectionStatus;
  String? get connectedDevice => _connectedDevice;
  List<AppInfo> get installedApps => _installedApps;
  List<AppInfo> get filteredApps => _filteredApps;
  Catalogue? get catalogue => _catalogue;
  AppMode get currentMode => _currentMode;
  String get searchQuery => _searchQuery;
  String? get currentApp => _currentApp;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isConnected => _connectionStatus == ConnectionStatus.connected;

  // Initialize the application
  Future<void> initialize() async {
    print('DEBUG: Provider initializing...');
    _setLoading(true);
    try {
      // Load catalogue
      print('DEBUG: Loading catalogue...');
      _catalogue = await _catalogueService.loadCatalogue();
      print('DEBUG: Catalogue loaded successfully');

      // Check if ADB is available
      print('DEBUG: Checking ADB availability...');
      final adbAvailable = await _adbService.checkAdbAvailable();
      print('DEBUG: ADB available: $adbAvailable');

      if (!adbAvailable) {
        print('DEBUG: ADB not available, setting error');
        _setError('ADB is not available. Please install ADB and add it to your PATH.');
        return;
      }

      print('DEBUG: Initialization completed successfully');
      _clearError();
    } catch (e) {
      print('DEBUG: Error during initialization: $e');
      _setError('Failed to initialize: $e');
    } finally {
      _setLoading(false);
    }
  } // Connect to Android device

  Future<void> connectToDevice() async {
    print('DEBUG: Provider connecting to device...');
    _setConnectionStatus(ConnectionStatus.connecting);
    _setLoading(true);

    try {
      // First check if ADB is available
      print('DEBUG: Provider checking ADB availability...');
      final adbAvailable = await _adbService.checkAdbAvailable();
      print('DEBUG: Provider ADB available result: $adbAvailable');

      if (!adbAvailable) {
        print('DEBUG: Provider - ADB not available');
        _setConnectionStatus(ConnectionStatus.error);
        _setError('ADB is not available. Please install Android SDK platform tools and add ADB to your PATH.');
        return;
      }

      // Try to get ADB status first
      print('DEBUG: Provider getting ADB status...');
      final status = await _adbService.getAdbStatus();
      print('DEBUG: Provider ADB status: $status');

      if (!status['available']) {
        print('DEBUG: Provider - ADB status shows not available');
        _setConnectionStatus(ConnectionStatus.error);
        _setError(status['suggestion'] ?? 'ADB not available');
        return;
      }

      // Try to connect to device
      print('DEBUG: Provider waiting for device...');
      final device = await _adbService.waitForDevice();
      print('DEBUG: Provider device result: $device');

      if (device != null) {
        print('DEBUG: Provider successfully connected to device: $device');
        _connectedDevice = device;
        _setConnectionStatus(ConnectionStatus.connected);
        await refreshApps();
      } else {
        print('DEBUG: Provider - no device returned');
        _setConnectionStatus(ConnectionStatus.error);
        _setError(
          'Failed to connect to device. Please ensure:\n'
          '• USB debugging is enabled on your Android device\n'
          '• Device is connected via USB\n'
          '• You have authorized the computer on your device',
        );
      }
    } catch (e) {
      print('DEBUG: Provider connection error: $e');
      _setConnectionStatus(ConnectionStatus.error);
      String errorMessage = e.toString();

      // Provide more helpful error messages
      if (errorMessage.contains('unauthorized')) {
        errorMessage =
            'Device is connected but not authorized.\n'
            'Please check your Android device and tap "Allow" when prompted for USB debugging.';
      } else if (errorMessage.contains('No device')) {
        errorMessage =
            'No Android device detected.\n'
            'Please connect your device via USB and enable USB debugging in Developer Options.';
      } else if (errorMessage.contains('ADB not available')) {
        errorMessage =
            'ADB (Android Debug Bridge) is not installed or not in PATH.\n'
            'Please install Android SDK platform tools.';
      }

      _setError(errorMessage);
    } finally {
      _setLoading(false);
    }
  }

  // Disconnect from device
  void disconnectFromDevice() {
    _adbService.disconnect();
    _connectedDevice = null;
    _installedApps.clear();
    _filteredApps.clear();
    _currentApp = null;
    _stopHunterMode();
    _setConnectionStatus(ConnectionStatus.disconnected);
    notifyListeners();
  }

  // Refresh installed apps
  Future<void> refreshApps() async {
    if (!isConnected) return;

    _setLoading(true);
    try {
      _installedApps = await _adbService.getAllAppsWithDetails();
      _applySearchFilter();
      _clearError();
    } catch (e) {
      _setError('Failed to refresh apps: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Set current mode
  void setMode(AppMode mode) {
    if (_currentMode == mode) return;

    _currentMode = mode;

    if (mode == AppMode.hunter) {
      _startHunterMode();
    } else {
      _stopHunterMode();
    }

    notifyListeners();
  }

  // Set search query and filter apps
  void setSearchQuery(String query) {
    _searchQuery = query;
    _applySearchFilter();
    notifyListeners();
  }

  // Apply search filter
  void _applySearchFilter() {
    if (_searchQuery.isEmpty) {
      _filteredApps = List.from(_installedApps);
    } else {
      _filteredApps = _installedApps.where((app) {
        return app.label.toLowerCase().contains(_searchQuery.toLowerCase()) || app.package.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
  }

  // Get apps that match catalogue
  List<AppInfo> getMatchingApps() {
    if (_catalogue == null) return [];

    final cataloguePackages = _catalogue!.getAllPackages();
    return _installedApps.where((app) => cataloguePackages.contains(app.package)).toList();
  }

  // Uninstall package
  Future<bool> uninstallPackage(String package) async {
    if (!isConnected) return false;

    try {
      final success = await _adbService.uninstallPackage(package);
      if (success) {
        // Add to catalogue under 'hunter' category
        await _catalogueService.addPackageToCatalogue(package, 'hunter');
        _catalogue = await _catalogueService.loadCatalogue();

        // Remove from installed apps
        _installedApps.removeWhere((app) => app.package == package);
        _applySearchFilter();
        notifyListeners();
      }
      return success;
    } catch (e) {
      _setError('Failed to uninstall $package: $e');
      return false;
    }
  }

  // Uninstall package and return whether it was added to catalogue
  Future<Map<String, dynamic>> uninstallPackageWithCatalogueInfo(String package) async {
    if (!isConnected) return {'success': false, 'addedToCatalogue': false};

    try {
      // Check if package is already in catalogue
      final wasInCatalogue = _catalogue?.containsPackage(package) ?? false;

      final success = await _adbService.uninstallPackage(package);
      if (success) {
        // Add to catalogue under 'hunter' category only if it wasn't already there
        bool addedToCatalogue = false;
        if (!wasInCatalogue) {
          await _catalogueService.addPackageToCatalogue(package, 'hunter');
          addedToCatalogue = true;
        }
        _catalogue = await _catalogueService.loadCatalogue();

        // Remove from installed apps
        _installedApps.removeWhere((app) => app.package == package);
        _applySearchFilter();
        notifyListeners();

        return {'success': true, 'addedToCatalogue': addedToCatalogue, 'package': package};
      }
      return {'success': false, 'addedToCatalogue': false};
    } catch (e) {
      _setError('Failed to uninstall $package: $e');
      return {'success': false, 'addedToCatalogue': false};
    }
  }

  // Backup and uninstall package
  Future<bool> backupAndUninstall(String package, String outputDir) async {
    if (!isConnected) return false;

    try {
      // First backup
      final backupPath = await _adbService.backupApk(package, outputDir);
      if (backupPath == null) {
        _setError('Failed to backup APK for $package');
        return false;
      }

      // Then uninstall
      final success = await _adbService.uninstallPackage(package);
      if (success) {
        // Add to catalogue under 'hunter' category
        await _catalogueService.addPackageToCatalogue(package, 'hunter');
        _catalogue = await _catalogueService.loadCatalogue();

        // Remove from installed apps
        _installedApps.removeWhere((app) => app.package == package);
        _applySearchFilter();
        notifyListeners();
      }
      return success;
    } catch (e) {
      _setError('Failed to backup and uninstall $package: $e');
      return false;
    }
  }

  // Backup and uninstall package with catalogue info
  Future<Map<String, dynamic>> backupAndUninstallWithCatalogueInfo(String package, String outputDir) async {
    if (!isConnected) return {'success': false, 'addedToCatalogue': false};

    try {
      // Check if package is already in catalogue
      final wasInCatalogue = _catalogue?.containsPackage(package) ?? false;

      // First backup
      final backupPath = await _adbService.backupApk(package, outputDir);
      if (backupPath == null) {
        _setError('Failed to backup APK for $package');
        return {'success': false, 'addedToCatalogue': false};
      }

      // Then uninstall
      final success = await _adbService.uninstallPackage(package);
      if (success) {
        // Add to catalogue under 'hunter' category only if it wasn't already there
        bool addedToCatalogue = false;
        if (!wasInCatalogue) {
          await _catalogueService.addPackageToCatalogue(package, 'hunter');
          addedToCatalogue = true;
        }
        _catalogue = await _catalogueService.loadCatalogue();

        // Remove from installed apps
        _installedApps.removeWhere((app) => app.package == package);
        _applySearchFilter();
        notifyListeners();

        return {'success': true, 'addedToCatalogue': addedToCatalogue, 'package': package};
      }
      return {'success': false, 'addedToCatalogue': false};
    } catch (e) {
      _setError('Failed to backup and uninstall $package: $e');
      return {'success': false, 'addedToCatalogue': false};
    }
  }

  // Start hunter mode
  void _startHunterMode() {
    if (!isConnected) return;

    _hunterTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      try {
        final currentApp = await _adbService.getCurrentApp();
        if (currentApp != null && currentApp != _currentApp) {
          _currentApp = currentApp;
          notifyListeners();
        }
      } catch (e) {
        // Ignore errors in hunter mode
      }
    });
  }

  // Stop hunter mode
  void _stopHunterMode() {
    _hunterTimer?.cancel();
    _hunterTimer = null;
    _currentApp = null;
  }

  // Restart ADB server
  Future<void> restartAdbServer() async {
    _setLoading(true);
    try {
      final success = await _adbService.startAdbServer();
      if (success) {
        _clearError();
        // Try to reconnect after restarting server
        await connectToDevice();
      } else {
        _setError('Failed to restart ADB server');
      }
    } catch (e) {
      _setError('Error restarting ADB server: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Private helper methods
  void _setConnectionStatus(ConnectionStatus status) {
    _connectionStatus = status;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Public method to clear error
  void clearError() {
    _clearError();
  }

  @override
  void dispose() {
    _stopHunterMode();
    super.dispose();
  }
}
