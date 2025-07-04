class AppInfo {
  final String package;
  final String label;
  final String version;
  final DateTime? installTime;
  final DateTime? updateTime;
  final String category;

  AppInfo({required this.package, required this.label, required this.version, this.installTime, this.updateTime, this.category = 'user'});

  factory AppInfo.fromMap(Map<String, dynamic> map) {
    return AppInfo(
      package: map['package'] ?? '',
      label: map['label'] ?? '',
      version: map['version'] ?? 'Unknown',
      installTime: map['installTime'] != null ? DateTime.parse(map['installTime']) : null,
      updateTime: map['updateTime'] != null ? DateTime.parse(map['updateTime']) : null,
      category: map['category'] ?? 'user',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'package': package,
      'label': label,
      'version': version,
      'installTime': installTime?.toIso8601String(),
      'updateTime': updateTime?.toIso8601String(),
      'category': category,
    };
  }

  @override
  String toString() {
    return 'AppInfo(package: $package, label: $label, version: $version)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppInfo && other.package == package;
  }

  @override
  int get hashCode => package.hashCode;
}
