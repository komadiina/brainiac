import 'package:flutter/material.dart';
import 'package:mozgalica/l10n/app_localizations.dart';

class WordleGamePipe {
  static String translate(BuildContext context, String key) {
    switch (key.toLowerCase()) {
      case 'present':
      return AppLocalizations.of(context)!.present.toUpperCase();
      case 'absent':
        return AppLocalizations.of(context)!.absent.toUpperCase();
      case 'correct':
        return AppLocalizations.of(context)!.correct.toUpperCase();
      case 'unknown':
        return AppLocalizations.of(context)!.unknown.toUpperCase();
      default: return key;
    }
  }
}