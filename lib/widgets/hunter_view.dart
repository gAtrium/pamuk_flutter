import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/pamuk_provider.dart';
import '../models/app_info.dart';
import '../l10n/app_localizations.dart';

class HunterView extends StatelessWidget {
  const HunterView({super.key});
  // Updated to show backup and uninstall for all apps

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Consumer<PamukProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Hunter mode info
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.my_location, color: Theme.of(context).colorScheme.primary, size: 32),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  localizations.hunterModeActive,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(localizations.monitoringCurrentApp),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(localizations.howItWorks, style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(localizations.step1),
                            Text(localizations.step2),
                            Text(localizations.step3),
                            Text(localizations.step4),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Current app display
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(localizations.currentApp, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),

                        if (provider.currentApp == null)
                          Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator(),
                                  const SizedBox(height: 16),
                                  Text(localizations.waitingForApp),
                                  const SizedBox(height: 8),
                                  Text(localizations.openAnyApp, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                ],
                              ),
                            ),
                          )
                        else
                          Expanded(child: _buildCurrentAppCard(context, localizations, provider)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurrentAppCard(BuildContext context, AppLocalizations localizations, PamukProvider provider) {
    final currentPackage = provider.currentApp!;
    final app = provider.installedApps.firstWhere(
      (app) => app.package == currentPackage,
      orElse: () => AppInfo(package: currentPackage, label: currentPackage, version: localizations.unknown),
    );

    final isInCatalogue = provider.catalogue?.containsPackage(currentPackage) ?? false;
    final category = provider.catalogue?.getPackageCategory(currentPackage);

    return Center(
      child: Card(
        elevation: 4,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // App icon and name
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: isInCatalogue ? Colors.red.withOpacity(0.1) : Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isInCatalogue ? Colors.red : Theme.of(context).colorScheme.primary, width: 2),
                ),
                child: Icon(
                  isInCatalogue ? Icons.warning : Icons.android,
                  size: 40,
                  color: isInCatalogue ? Colors.red : Theme.of(context).colorScheme.primary,
                ),
              ),

              const SizedBox(height: 16),

              // App details
              Text(
                app.label,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                app.package,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),

              if (app.version != localizations.unknown) ...[
                const SizedBox(height: 4),
                Text('${localizations.version}: ${app.version}', style: Theme.of(context).textTheme.bodySmall),
              ],

              // Warning if in catalogue
              if (isInCatalogue) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.warning, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(
                        localizations.knownSuspiciousApp(category?.toUpperCase() ?? localizations.suspicious),
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isInCatalogue)
                    ElevatedButton.icon(
                      onPressed: () => _showUninstallDialog(context, localizations, provider, app),
                      icon: const Icon(Icons.delete),
                      label: Text(localizations.uninstallNow),
                      style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.red),
                    )
                  else
                    OutlinedButton.icon(
                      onPressed: () => _showUninstallDialog(context, localizations, provider, app),
                      icon: const Icon(Icons.delete),
                      label: Text(localizations.uninstall),
                    ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () => _showBackupUninstallDialog(context, localizations, provider, app),
                    icon: const Icon(Icons.backup),
                    label: Text(localizations.backupAndUninstall),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUninstallDialog(BuildContext context, AppLocalizations localizations, PamukProvider provider, AppInfo app) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.uninstallApp),
        content: Text(localizations.confirmUninstall(app.label)),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(localizations.cancel)),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final result = await provider.uninstallPackageWithCatalogueInfo(app.package);

              if (context.mounted) {
                if (result['success']) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(localizations.uninstallSuccess), backgroundColor: Colors.green));

                  // Show contribution dialog if package was added to catalogue
                  if (result['addedToCatalogue']) {
                    _showContributeDialog(context, localizations, result['package']);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(localizations.uninstallError), backgroundColor: Colors.red));
                }
              }
            },
            style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.red),
            child: Text(localizations.uninstall),
          ),
        ],
      ),
    );
  }

  void _showBackupUninstallDialog(BuildContext context, AppLocalizations localizations, PamukProvider provider, AppInfo app) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.backupAndUninstall),
        content: Text(localizations.backupApkMessage(app.label)),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(localizations.cancel)),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final result = await provider.backupAndUninstallWithCatalogueInfo(app.package, 'apk_backups');

              if (context.mounted) {
                if (result['success']) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(localizations.backupSuccess), backgroundColor: Colors.green));

                  // Show contribution dialog if package was added to catalogue
                  if (result['addedToCatalogue']) {
                    _showContributeDialog(context, localizations, result['package']);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(localizations.backupError), backgroundColor: Colors.red));
                }
              }
            },
            child: Text(localizations.backupAndUninstall),
          ),
        ],
      ),
    );
  }

  void _showContributeDialog(BuildContext context, AppLocalizations localizations, String packageName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.contributeToRepository),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(localizations.packageAddedToCatalogue(packageName, 'hunter')),
            const SizedBox(height: 16),
            Text(localizations.considerContributing),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(localizations.notNow)),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final url = Uri.parse('https://github.com/gAtrium/pamuk');
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              }
            },
            child: Text(localizations.openGitHub),
          ),
        ],
      ),
    );
  }
}
