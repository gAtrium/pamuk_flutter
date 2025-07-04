import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/pamuk_provider.dart';
import '../l10n/app_localizations.dart';

class ModeSelector extends StatelessWidget {
  const ModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Consumer<PamukProvider>(
      builder: (context, provider, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Text(localizations.mode, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  children: [
                    _buildModeButton(
                      context,
                      AppMode.catalogue,
                      localizations.catalogueMode,
                      Icons.list_alt,
                      localizations.catalogueModeDescription,
                      provider,
                    ),
                    const SizedBox(width: 8),
                    _buildModeButton(
                      context,
                      AppMode.hunter,
                      localizations.hunterMode,
                      Icons.my_location,
                      localizations.hunterModeDescription,
                      provider,
                    ),
                    const SizedBox(width: 8),
                    _buildModeButton(context, AppMode.appList, localizations.appListMode, Icons.apps, localizations.appListModeDescription, provider),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModeButton(BuildContext context, AppMode mode, String title, IconData icon, String tooltip, PamukProvider provider) {
    final isSelected = provider.currentMode == mode;

    return Expanded(
      child: Tooltip(
        message: tooltip,
        child: ElevatedButton.icon(
          onPressed: () => provider.setMode(mode),
          icon: Icon(icon),
          label: Text(title),
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface,
            foregroundColor: isSelected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurface,
            elevation: isSelected ? 4 : 1,
          ),
        ),
      ),
    );
  }
}
