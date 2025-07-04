import 'dart:io';
import 'package:yaml/yaml.dart';
import '../models/catalogue.dart';

class CatalogueService {
  static const String defaultCatalogueContent = '''
catalogue:
  adware:
    - com.qrscanner.qrueser
    - com.jouirlb.emonest
    - com.solara.pdfreader.pdfeditor
    - com.timeize.lessbtly
    - com.pdf.reader.fileviewer
  hunter:
    - com.shield.cleanjunk.tool
    - io.kodular.titk.clean.junk
    - com.junk.clean.cache.clean
    - com.think.find.hsuah.game
    - com.coders8.alfanni
    - mobeasyapp.math.calculator
    - com.mysuruhawking.flutter_grocery
    - com.quickmathto.resolver
    - daily.connect.wifihelper
''';

  Future<Catalogue> loadCatalogue([String? filePath]) async {
    filePath ??= 'catalogue.yaml';

    try {
      final file = File(filePath);
      String content;

      if (await file.exists()) {
        content = await file.readAsString();
      } else {
        // Create default catalogue if file doesn't exist
        content = defaultCatalogueContent;
        await file.writeAsString(content);
      }

      final yaml = loadYaml(content);
      final Map<String, dynamic> yamlMap = {};
      if (yaml is Map) {
        yaml.forEach((key, value) {
          yamlMap[key.toString()] = value;
        });
      }
      return Catalogue.fromMap(yamlMap);
    } catch (e) {
      // Return catalogue with default content if loading fails
      final yaml = loadYaml(defaultCatalogueContent);
      final Map<String, dynamic> yamlMap = {};
      if (yaml is Map) {
        yaml.forEach((key, value) {
          yamlMap[key.toString()] = value;
        });
      }
      return Catalogue.fromMap(yamlMap);
    }
  }

  Future<bool> saveCatalogue(Catalogue catalogue, [String? filePath]) async {
    filePath ??= 'catalogue.yaml';

    try {
      final file = File(filePath);
      final content = _mapToYaml(catalogue.toMap());
      await file.writeAsString(content);
      return true;
    } catch (e) {
      return false;
    }
  }

  String _mapToYaml(Map<String, dynamic> map) {
    final buffer = StringBuffer();
    _writeYamlMap(buffer, map, 0);
    return buffer.toString();
  }

  void _writeYamlMap(StringBuffer buffer, Map<String, dynamic> map, int indent) {
    final indentStr = '  ' * indent;

    for (final entry in map.entries) {
      buffer.write('$indentStr${entry.key}:');

      if (entry.value is Map) {
        buffer.writeln();
        _writeYamlMap(buffer, entry.value as Map<String, dynamic>, indent + 1);
      } else if (entry.value is List) {
        buffer.writeln();
        for (final item in entry.value as List) {
          buffer.writeln('$indentStr  - $item');
        }
      } else {
        buffer.writeln(' ${entry.value}');
      }
    }
  }

  Future<void> addPackageToCatalogue(String package, String category, [String? filePath]) async {
    final catalogue = await loadCatalogue(filePath);
    catalogue.addPackage(package, category);
    await saveCatalogue(catalogue, filePath);
  }
}
