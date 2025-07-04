import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/locale_provider.dart';
import '../l10n/app_localizations.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context);

    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language),
      tooltip: localizations.language,
      onSelected: (Locale locale) {
        localeProvider.setLocale(locale);
      },
      itemBuilder: (BuildContext context) {
        return LocaleProvider.supportedLocales.map((Locale locale) {
          final languageName = LocaleProvider.localeNames[locale.languageCode] ?? locale.languageCode;

          return PopupMenuItem<Locale>(
            value: locale,
            child: Row(
              children: [
                Icon(Icons.check, size: 16, color: localeProvider.locale == locale ? Theme.of(context).primaryColor : Colors.transparent),
                const SizedBox(width: 8),
                Text(languageName),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}
