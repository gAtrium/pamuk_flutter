import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/pamuk_provider.dart';
import '../widgets/connection_widget.dart';
import '../widgets/mode_selector.dart';
import '../widgets/catalogue_view.dart';
import '../widgets/hunter_view.dart';
import '../widgets/app_list_view.dart';
import '../widgets/language_selector.dart';
import '../screens/settings_screen.dart';
import '../l10n/app_localizations.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PamukProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/pamuk_icon.png',
              width: 32,
              height: 32,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.android, size: 32);
              },
            ),
            const SizedBox(width: 8),
            Text(localizations.appTitle),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Consumer<PamukProvider>(
            builder: (context, provider, child) {
              if (provider.isConnected) {
                return IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: provider.isLoading
                      ? null
                      : () {
                          provider.refreshApps();
                        },
                  tooltip: localizations.refreshApps,
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const LanguageSelector(),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'settings') {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SettingsScreen()));
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'settings',
                child: Row(children: [const Icon(Icons.settings), const SizedBox(width: 8), Text(localizations.settings)]),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<PamukProvider>(
        builder: (context, provider, child) {
          final localizations = AppLocalizations.of(context)!;

          if (provider.isLoading && !provider.isConnected) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [const CircularProgressIndicator(), const SizedBox(height: 16), Text(localizations.connecting)],
              ),
            );
          }

          if (provider.errorMessage != null && !provider.isConnected) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
                  const SizedBox(height: 16),
                  Text(localizations.error, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(provider.errorMessage!, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(onPressed: () => provider.initialize(), child: Text(localizations.connectToDevice)),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Connection status
              const ConnectionWidget(),

              // Mode selector (only show when connected)
              if (provider.isConnected) ...[const Divider(height: 1), const ModeSelector()],

              // Error message bar
              if (provider.errorMessage != null && provider.isConnected)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  color: Theme.of(context).colorScheme.errorContainer,
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(provider.errorMessage!, style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer)),
                      ),
                      IconButton(icon: const Icon(Icons.close), onPressed: () => provider.clearError(), color: Theme.of(context).colorScheme.error),
                    ],
                  ),
                ),

              // Main content
              Expanded(child: _buildMainContent(provider)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMainContent(PamukProvider provider) {
    final localizations = AppLocalizations.of(context)!;

    if (!provider.isConnected) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.phone_android, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(localizations.noDeviceConnected, style: const TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 8),
            Text(localizations.noDeviceConnectedDescription, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    switch (provider.currentMode) {
      case AppMode.catalogue:
        return const CatalogueView();
      case AppMode.hunter:
        return const HunterView();
      case AppMode.appList:
        return const AppListView();
    }
  }
}
