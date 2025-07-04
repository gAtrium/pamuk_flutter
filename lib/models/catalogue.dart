class Catalogue {
  final Map<String, List<String>> packages;

  Catalogue({required this.packages});

  factory Catalogue.fromMap(Map<String, dynamic> map) {
    final packages = <String, List<String>>{};
    final catalogueData = map['catalogue'];

    if (catalogueData is Map) {
      catalogueData.forEach((key, value) {
        final keyStr = key.toString();
        if (value is List) {
          packages[keyStr] = value.map((e) => e.toString()).toList();
        } else if (value is Iterable) {
          packages[keyStr] = value.map((e) => e.toString()).toList();
        }
      });
    }

    return Catalogue(packages: packages);
  }

  Map<String, dynamic> toMap() {
    return {'catalogue': packages};
  }

  List<String> getAllPackages() {
    final allPackages = <String>[];
    for (final packageList in packages.values) {
      allPackages.addAll(packageList);
    }
    return allPackages;
  }

  String? getPackageCategory(String package) {
    for (final entry in packages.entries) {
      if (entry.value.contains(package)) {
        return entry.key;
      }
    }
    return null;
  }

  void addPackage(String package, String category) {
    if (!packages.containsKey(category)) {
      packages[category] = [];
    }
    if (!packages[category]!.contains(package)) {
      packages[category]!.add(package);
    }
  }

  bool containsPackage(String package) {
    return getAllPackages().contains(package);
  }
}
