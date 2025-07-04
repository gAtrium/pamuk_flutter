import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/locale_provider.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.settings), backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(localizations.language, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 16),
                    Consumer<LocaleProvider>(
                      builder: (context, localeProvider, child) {
                        return Column(
                          children: LocaleProvider.supportedLocales.map((locale) {
                            final languageName = LocaleProvider.localeNames[locale.languageCode] ?? locale.languageCode;
                            final isSelected = localeProvider.locale == locale;

                            return RadioListTile<Locale>(
                              title: Text(languageName),
                              subtitle: Text(locale.languageCode.toUpperCase()),
                              value: locale,
                              groupValue: localeProvider.locale,
                              onChanged: (Locale? value) {
                                if (value != null) {
                                  localeProvider.setLocale(value);
                                }
                              },
                              selected: isSelected,
                              activeColor: Theme.of(context).primaryColor,
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(localizations.about, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 16),
                    Text(localizations.aboutDescription, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.android, color: Colors.green),
                        const SizedBox(width: 8),
                        Text('Version 1.0.0', style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
