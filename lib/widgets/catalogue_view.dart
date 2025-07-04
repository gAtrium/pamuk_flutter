import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../services/pamuk_provider.dart';
import '../models/app_info.dart';

class CatalogueView extends StatelessWidget {
  const CatalogueView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<PamukProvider>(
      builder: (context, provider, child) {
        final matchingApps = provider.getMatchingApps();

        if (provider.isLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CircularProgressIndicator(), SizedBox(height: 16), Text(l10n.scanningAdware)],
            ),
          );
        }

        if (matchingApps.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, size: 64, color: Colors.green[600]),
                const SizedBox(height: 16),
                Text(
                  l10n.noAdwareFound,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.green[600], fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(l10n.deviceClean, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => provider.setMode(AppMode.hunter),
                  icon: const Icon(Icons.my_location),
                  label: Text(l10n.switchToHunterMode),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                border: const Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Theme.of(context).colorScheme.error, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.adwareDetected,
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          l10n.suspiciousPackagesFound(matchingApps.length),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onErrorContainer),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showUninstallAllDialog(context, provider, matchingApps),
                    icon: const Icon(Icons.delete_sweep),
                    label: Text(l10n.uninstallAll),
                    style: ElevatedButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
                  ),
                ],
              ),
            ),

            // List of matching apps
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: matchingApps.length,
                itemBuilder: (context, index) {
                  final app = matchingApps[index];
                  final category = provider.catalogue?.getPackageCategory(app.package) ?? l10n.unknown;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getCategoryColor(category),
                        child: Icon(Icons.warning, color: Colors.white),
                      ),
                      title: Text(app.label, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(app.package),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(color: _getCategoryColor(category), borderRadius: BorderRadius.circular(12)),
                                child: Text(
                                  category.toUpperCase(),
                                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text('v${app.version}', style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                        ],
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == 'uninstall') {
                            _showUninstallDialog(context, provider, app);
                          } else if (value == 'backup_uninstall') {
                            _showBackupUninstallDialog(context, provider, app);
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'uninstall',
                            child: ListTile(leading: Icon(Icons.delete), title: Text(l10n.uninstall), contentPadding: EdgeInsets.zero),
                          ),
                          PopupMenuItem(
                            value: 'backup_uninstall',
                            child: ListTile(leading: Icon(Icons.backup), title: Text(l10n.backupAndUninstall), contentPadding: EdgeInsets.zero),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'adware':
        return Colors.red;
      case 'hunter':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _showUninstallAllDialog(BuildContext context, PamukProvider provider, List<AppInfo> apps) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.uninstallAllAdware),
        content: Text(
          '${l10n.confirmUninstallAll(apps.length)}\n\n'
          '${l10n.thisActionCannotBeUndone}',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel)),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();

              for (final app in apps) {
                await provider.uninstallPackage(app.package);
              }

              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l10n.uninstalledPackages(apps.length)), backgroundColor: Colors.green));
              }
            },
            style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.red),
            child: Text(l10n.uninstallAll),
          ),
        ],
      ),
    );
  }

  void _showUninstallDialog(BuildContext context, PamukProvider provider, AppInfo app) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.uninstallApp),
        content: Text(l10n.confirmUninstall(app.label)),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel)),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final success = await provider.uninstallPackage(app.package);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? l10n.successfullyUninstalled(app.label) : l10n.failedToUninstall(app.label)),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.red),
            child: Text(l10n.uninstall),
          ),
        ],
      ),
    );
  }

  void _showBackupUninstallDialog(BuildContext context, PamukProvider provider, AppInfo app) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.backupAndUninstall),
        content: Text(l10n.backupApkMessage(app.label)),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel)),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final success = await provider.backupAndUninstall(app.package, 'apk_backups');

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? l10n.successfullyBackedUpAndUninstalled(app.label) : l10n.failedToBackupAndUninstall(app.label)),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            child: Text(l10n.backupAndUninstall),
          ),
        ],
      ),
    );
  }
}
