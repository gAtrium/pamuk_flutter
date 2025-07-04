import 'dart:io';
import 'package:process/process.dart';
import '../models/app_info.dart';

class AdbService {
  final ProcessManager _processManager;
  String? _connectedDevice;

  AdbService({ProcessManager? processManager}) : _processManager = processManager ?? const LocalProcessManager();

  Future<bool> checkAdbAvailable() async {
    print('DEBUG: Checking ADB availability...');
    try {
      print('DEBUG: Running command: adb version');
      final result = await _processManager.run(['adb', 'version']);
      print('DEBUG: ADB version exit code: ${result.exitCode}');
      if (result.exitCode == 0) {
        print('DEBUG: ADB version stdout: ${result.stdout}');
        print('DEBUG: ADB is available');
        return true;
      } else {
        print('DEBUG: ADB version stderr: ${result.stderr}');
        print('DEBUG: ADB version failed with exit code: ${result.exitCode}');
        return false;
      }
    } catch (e) {
      print('DEBUG: Exception while checking ADB: $e');
      return false;
    }
  }

  Future<bool> startAdbServer() async {
    print('DEBUG: Starting ADB server...');
    try {
      // Kill any existing ADB server first
      print('DEBUG: Killing existing ADB server...');
      final killResult = await _processManager.run(['adb', 'kill-server']);
      print('DEBUG: Kill server exit code: ${killResult.exitCode}');

      // Start ADB server
      print('DEBUG: Starting ADB server...');
      final result = await _processManager.run(['adb', 'start-server']);
      print('DEBUG: Start server exit code: ${result.exitCode}');
      if (result.exitCode == 0) {
        print('DEBUG: ADB server started successfully');
        print('DEBUG: Start server stdout: ${result.stdout}');
        return true;
      } else {
        print('DEBUG: Start server stderr: ${result.stderr}');
        return false;
      }
    } catch (e) {
      print('DEBUG: Exception while starting ADB server: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> getAdbStatus() async {
    print('DEBUG: Getting ADB status...');
    try {
      // Check if ADB is available
      print('DEBUG: Running adb version to check availability...');
      final versionResult = await _processManager.run(['adb', 'version']);
      print('DEBUG: ADB version exit code: ${versionResult.exitCode}');

      if (versionResult.exitCode != 0) {
        print('DEBUG: ADB version failed - not available in PATH');
        return {
          'available': false,
          'error': 'ADB not found in PATH',
          'suggestion': 'Please install Android SDK platform tools and add ADB to your PATH',
        };
      }

      print('DEBUG: ADB is available, checking devices...');
      // Check devices
      final devicesResult = await _processManager.run(['adb', 'devices']);
      print('DEBUG: ADB devices exit code: ${devicesResult.exitCode}');
      final output = devicesResult.stdout.toString();
      print('DEBUG: ADB devices output: $output');
      final lines = output.split('\n');

      final devices = <String>[];
      bool hasUnauthorized = false;

      for (final line in lines.skip(1)) {
        final parts = line.trim().split('\t');
        print('DEBUG: Processing device line: "${line.trim()}"');
        if (parts.length >= 2) {
          if (parts[1] == 'device') {
            devices.add(parts[0]);
            print('DEBUG: Found authorized device: ${parts[0]}');
          } else if (parts[1] == 'unauthorized') {
            hasUnauthorized = true;
            print('DEBUG: Found unauthorized device: ${parts[0]}');
          } else {
            print('DEBUG: Found device in state "${parts[1]}": ${parts[0]}');
          }
        }
      }

      print('DEBUG: Total authorized devices: ${devices.length}');
      print('DEBUG: Has unauthorized devices: $hasUnauthorized');

      if (hasUnauthorized) {
        return {
          'available': true,
          'connected': false,
          'error': 'Device unauthorized',
          'suggestion': 'Please allow USB debugging on your Android device',
        };
      }

      if (devices.isEmpty) {
        return {
          'available': true,
          'connected': false,
          'error': 'No devices connected',
          'suggestion': 'Please connect an Android device with USB debugging enabled',
        };
      }

      print('DEBUG: Returning successful connection with primary device: ${devices.first}');
      return {'available': true, 'connected': true, 'devices': devices, 'primary_device': devices.first};
    } catch (e) {
      print('DEBUG: Exception in getAdbStatus: $e');
      return {'available': false, 'error': 'Failed to check ADB status: $e', 'suggestion': 'Please check your ADB installation'};
    }
  }

  Future<String?> waitForDevice() async {
    print('DEBUG: Starting waitForDevice...');
    try {
      // First check ADB status
      print('DEBUG: Checking ADB status...');
      final status = await getAdbStatus();
      print('DEBUG: ADB status result: $status');

      if (!status['available']) {
        print('DEBUG: ADB not available, throwing exception');
        throw Exception(status['error'] ?? 'ADB not available');
      }

      if (status['connected']) {
        print('DEBUG: Device already connected: ${status['primary_device']}');
        _connectedDevice = status['primary_device'];
        return _connectedDevice;
      }

      // If not connected, try to start ADB server
      print('DEBUG: No device connected, starting ADB server...');
      final serverStarted = await startAdbServer();
      if (!serverStarted) {
        print('DEBUG: Failed to start ADB server');
        throw Exception('Failed to start ADB server');
      }

      // Wait a bit for server to start
      print('DEBUG: Waiting 2 seconds for server to initialize...');
      await Future.delayed(const Duration(seconds: 2));

      // Check status again
      print('DEBUG: Checking status again after server start...');
      final newStatus = await getAdbStatus();
      print('DEBUG: New status after server start: $newStatus');

      if (newStatus['connected']) {
        print('DEBUG: Device now connected: ${newStatus['primary_device']}');
        _connectedDevice = newStatus['primary_device'];
        return _connectedDevice;
      }

      // If still not connected, throw error with suggestion
      print('DEBUG: Still no device connected after server start');
      throw Exception(newStatus['suggestion'] ?? 'No device connected');
    } catch (e) {
      print('DEBUG: Exception in waitForDevice: $e');
      rethrow;
    }
  }

  Future<List<String>> getInstalledPackages() async {
    if (_connectedDevice == null) {
      throw Exception('No device connected');
    }

    try {
      final result = await _processManager.run(['adb', '-s', _connectedDevice!, 'shell', 'pm', 'list', 'packages']);

      if (result.exitCode != 0) {
        throw Exception('Failed to get packages');
      }

      final output = result.stdout.toString();
      final packages = <String>[];

      for (final line in output.split('\n')) {
        if (line.startsWith('package:')) {
          packages.add(line.substring(8).trim());
        }
      }

      return packages;
    } catch (e) {
      throw Exception('Error getting packages: $e');
    }
  }

  Future<List<AppInfo>> getAllAppsWithDetails() async {
    final packages = await getInstalledPackages();

    // Filter out system packages
    final userPackages = packages
        .where((pkg) => !pkg.startsWith('com.android.') && !pkg.startsWith('com.google.android.') && !pkg.startsWith('android.'))
        .toList();

    final apps = <AppInfo>[];

    for (final package in userPackages) {
      try {
        final details = await getPackageDetails(package);
        if (details != null) {
          apps.add(details);
        }
      } catch (e) {
        // Skip packages that fail to get details
        continue;
      }
    }

    // Sort by installation date (newest first)
    apps.sort((a, b) {
      if (a.installTime == null && b.installTime == null) return 0;
      if (a.installTime == null) return 1;
      if (b.installTime == null) return -1;
      return b.installTime!.compareTo(a.installTime!);
    });

    return apps;
  }

  Future<AppInfo?> getPackageDetails(String package) async {
    if (_connectedDevice == null) {
      throw Exception('No device connected');
    }

    try {
      final result = await _processManager.run(['adb', '-s', _connectedDevice!, 'shell', 'dumpsys', 'package', package]);

      if (result.exitCode != 0) {
        return null;
      }

      final output = result.stdout.toString();
      final lines = output.split('\n');

      String label = package;
      String version = 'Unknown';
      DateTime? installTime;
      DateTime? updateTime;

      for (final line in lines) {
        final trimmed = line.trim();

        if (trimmed.startsWith('versionName=')) {
          version = trimmed.split('=')[1];
        } else if (trimmed.startsWith('firstInstallTime=')) {
          final timestamp = trimmed.split('=')[1];
          try {
            // Try parsing as milliseconds since epoch
            final timestampMs = int.tryParse(timestamp);
            if (timestampMs != null) {
              installTime = DateTime.fromMillisecondsSinceEpoch(timestampMs);
            } else {
              // Try parsing as date string
              installTime = DateTime.parse(timestamp);
            }
          } catch (e) {
            // Ignore parsing errors
          }
        } else if (trimmed.startsWith('lastUpdateTime=')) {
          final timestamp = trimmed.split('=')[1];
          try {
            final timestampMs = int.tryParse(timestamp);
            if (timestampMs != null) {
              updateTime = DateTime.fromMillisecondsSinceEpoch(timestampMs);
            } else {
              updateTime = DateTime.parse(timestamp);
            }
          } catch (e) {
            // Ignore parsing errors
          }
        }
      }

      // Try to get human-readable app name
      try {
        final labelResult = await _processManager.run(['adb', '-s', _connectedDevice!, 'shell', 'pm', 'list', 'packages', '-f', package]);

        if (labelResult.exitCode == 0) {
          final labelOutput = labelResult.stdout.toString().trim();
          if (labelOutput.contains('=')) {
            final apkPath = labelOutput.split('=')[0].replaceFirst('package:', '');

            // Try to get app label using aapt
            final aaptResult = await _processManager.run(['adb', '-s', _connectedDevice!, 'shell', 'aapt', 'dump', 'badging', apkPath]);

            if (aaptResult.exitCode == 0) {
              final aaptOutput = aaptResult.stdout.toString();
              for (final line in aaptOutput.split('\n')) {
                if (line.startsWith('application-label:')) {
                  final parts = line.split("'");
                  if (parts.length >= 2) {
                    label = parts[1];
                    break;
                  }
                }
              }
            }
          }
        }
      } catch (e) {
        // Keep default package name as label
      }

      return AppInfo(package: package, label: label, version: version, installTime: installTime, updateTime: updateTime);
    } catch (e) {
      return null;
    }
  }

  Future<bool> uninstallPackage(String package) async {
    if (_connectedDevice == null) {
      throw Exception('No device connected');
    }

    try {
      final result = await _processManager.run(['adb', '-s', _connectedDevice!, 'shell', 'pm', 'uninstall', package]);

      return result.exitCode == 0;
    } catch (e) {
      return false;
    }
  }

  Future<String?> getCurrentApp() async {
    if (_connectedDevice == null) {
      throw Exception('No device connected');
    }

    try {
      // Get Android version first to determine the correct command
      final versionResult = await _processManager.run(['adb', '-s', _connectedDevice!, 'shell', 'getprop', 'ro.build.version.release']);

      int androidVersion = 0;
      if (versionResult.exitCode == 0) {
        final versionOutput = versionResult.stdout.toString().trim();
        try {
          androidVersion = int.parse(versionOutput.split('.')[0]);
        } catch (e) {
          androidVersion = 0;
        }
      }

      // Use appropriate command based on Android version
      List<String> command;
      if (androidVersion >= 10) {
        command = ['adb', '-s', _connectedDevice!, 'shell', 'dumpsys', 'window', 'displays'];
      } else {
        command = ['adb', '-s', _connectedDevice!, 'shell', 'dumpsys', 'window'];
      }

      final result = await _processManager.run(command);

      if (result.exitCode != 0) {
        return null;
      }

      final output = result.stdout.toString();
      final lines = output.split('\n');

      for (final line in lines) {
        if (line.contains('mCurrentFocus=')) {
          // Parse the output to get package name
          // Format: mCurrentFocus=Window{hash u0 package/activity}
          final parts = line.trim().split(' ');
          for (final part in parts) {
            if (part.contains('/')) {
              return part.split('/')[0];
            }
          }
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<String?> backupApk(String package, String outputDir) async {
    if (_connectedDevice == null) {
      throw Exception('No device connected');
    }

    try {
      // Create output directory if it doesn't exist
      final dir = Directory(outputDir);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      // Get APK path on device
      final pathResult = await _processManager.run(['adb', '-s', _connectedDevice!, 'shell', 'pm', 'path', package]);

      if (pathResult.exitCode != 0) {
        return null;
      }

      final pathOutput = pathResult.stdout.toString().trim();
      if (!pathOutput.startsWith('package:')) {
        return null;
      }

      final apkPath = pathOutput.substring(8); // Remove 'package:' prefix

      // Create output filename with timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final outputFilename = '${package}_$timestamp.apk';
      final outputPath = '$outputDir/$outputFilename';

      // Pull the APK file
      final pullResult = await _processManager.run(['adb', '-s', _connectedDevice!, 'pull', apkPath, outputPath]);

      if (pullResult.exitCode == 0 && await File(outputPath).exists()) {
        return outputPath;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  String? get connectedDevice => _connectedDevice;

  void disconnect() {
    _connectedDevice = null;
  }
}
