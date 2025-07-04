import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../services/pamuk_provider.dart';
import '../models/app_info.dart';

class AppListView extends StatefulWidget {
  const AppListView({super.key});

  @override
  State<AppListView> createState() => _AppListViewState();
}

class _AppListViewState extends State<AppListView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      context.read<PamukProvider>().setSearchQuery(_searchController.text);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<PamukProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.installedApps.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CircularProgressIndicator(), SizedBox(height: 16), Text(l10n.loadingAppsMessage)],
            ),
          );
        }

        return Column(
          children: [
            // Search bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: l10n.searchApps,
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                },
                              )
                            : null,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    l10n.appsCount(provider.filteredApps.length),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            // Apps list
            Expanded(
              child: provider.filteredApps.isEmpty
                  ? _buildEmptyState(context, provider)
                  : Scrollbar(
                      controller: _scrollController,
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: provider.filteredApps.length,
                        itemBuilder: (context, index) {
                          final app = provider.filteredApps[index];
                          return _buildAppCard(context, provider, app, index + 1, l10n);
                        },
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, PamukProvider provider) {
    final l10n = AppLocalizations.of(context)!;

    if (provider.searchQuery.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(l10n.noAppsFoundSearch, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.grey)),
            const SizedBox(height: 8),
            Text(l10n.adjustSearchTerms, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.apps, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(l10n.noAppsFound, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.grey)),
          const SizedBox(height: 8),
          Text(l10n.tryRefreshing, style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: () => provider.refreshApps(), child: Text(l10n.refresh)),
        ],
      ),
    );
  }

  Widget _buildAppCard(BuildContext context, PamukProvider provider, AppInfo app, int index, AppLocalizations l10n) {
    final isInCatalogue = provider.catalogue?.containsPackage(app.package) ?? false;
    final category = provider.catalogue?.getPackageCategory(app.package);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: isInCatalogue ? 4 : 1,
      color: isInCatalogue ? Colors.red.withOpacity(0.05) : null,
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Index number
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
              child: Center(
                child: Text(
                  index.toString(),
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // App icon
            CircleAvatar(
              backgroundColor: isInCatalogue ? Colors.red.withOpacity(0.1) : Theme.of(context).colorScheme.primaryContainer,
              child: Icon(isInCatalogue ? Icons.warning : Icons.android, color: isInCatalogue ? Colors.red : Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
        title: Text(
          app.label,
          style: TextStyle(fontWeight: FontWeight.bold, color: isInCatalogue ? Colors.red[700] : null),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(app.package),
            const SizedBox(height: 4),
            Row(
              children: [
                if (isInCatalogue) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                    child: Text(
                      (category ?? 'SUSPICIOUS').toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Text('v${app.version}', style: Theme.of(context).textTheme.bodySmall),
                if (app.installTime != null) ...[
                  const SizedBox(width: 8),
                  Text(DateFormat('MMM d, y', l10n.localeName).format(app.installTime!), style: Theme.of(context).textTheme.bodySmall),
                ],
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
            } else if (value == 'details') {
              _showAppDetailsDialog(context, app);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'details',
              child: ListTile(leading: Icon(Icons.info), title: Text(l10n.details), contentPadding: EdgeInsets.zero),
            ),
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
  }

  void _showAppDetailsDialog(BuildContext context, AppInfo app) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(app.label),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(l10n.package, app.package),
            _buildDetailRow(l10n.version, app.version),
            if (app.installTime != null) _buildDetailRow(l10n.installed, DateFormat('MMM d, y HH:mm', l10n.localeName).format(app.installTime!)),
            if (app.updateTime != null) _buildDetailRow(l10n.updated, DateFormat('MMM d, y HH:mm', l10n.localeName).format(app.updateTime!)),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.close))],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(value)),
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
