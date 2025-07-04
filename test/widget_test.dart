// Basic unit tests for Pamuk Desktop
//
// These tests verify core functionality without requiring UI rendering
// which makes them suitable for CI/CD environments.

import 'package:flutter_test/flutter_test.dart';
import 'package:pamuk_desktop/models/app_info.dart';
import 'package:pamuk_desktop/models/catalogue.dart';

void main() {
  group('AppInfo Model Tests', () {
    test('AppInfo should be created with correct properties', () {
      final app = AppInfo(
        package: 'com.example.test',
        label: 'Test App',
        version: '1.0.0',
        category: 'user',
      );

      expect(app.package, 'com.example.test');
      expect(app.label, 'Test App');
      expect(app.version, '1.0.0');
      expect(app.category, 'user');
    });

    test('AppInfo should handle optional fields', () {
      final now = DateTime.now();
      final app = AppInfo(
        package: 'com.example.test2',
        label: 'Test App 2',
        version: '2.0.0',
        installTime: now,
        updateTime: now,
        category: 'system',
      );

      expect(app.installTime, now);
      expect(app.updateTime, now);
      expect(app.category, 'system');
    });
  });

  group('Catalogue Model Tests', () {
    test('Catalogue should be created with packages map', () {
      final packages = {
        'adware': ['com.example.ad1', 'com.example.ad2'],
        'malware': ['com.example.mal1'],
      };
      
      final catalogue = Catalogue(packages: packages);

      expect(catalogue.packages, packages);
      expect(catalogue.packages['adware'], contains('com.example.ad1'));
      expect(catalogue.packages['malware'], contains('com.example.mal1'));
    });

    test('Catalogue should handle empty packages', () {
      final catalogue = Catalogue(packages: {});
      
      expect(catalogue.packages, isEmpty);
    });
  });
}
