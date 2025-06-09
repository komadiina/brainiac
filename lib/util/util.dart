import 'package:flutter/material.dart';

import '../db/repository/game_result_repository.dart';
import '../l10n/app_localizations.dart';

class Utilities {
  static final Map<String, String Function(AppLocalizations)> gameNameLookupMap = {
    'tictactoe': (l10n) => l10n.tictactoe,
    'wordle': (l10n) => l10n.wordle,
    'nerdle': (l10n) => l10n.nerdle,
  };

  static Future<void> gameFinishDialog(
      BuildContext context,
      double score,
      String game,
      ) async {
    TextEditingController usernameController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.pleaseEnterUsername),
        content: TextField(
          controller: usernameController,
          onSubmitted: (username) {
            GameResultRepository.saveGameAttempt(username, game, score);
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              GameResultRepository.saveGameAttempt(usernameController.text, game, score);
              Navigator.of(context).pop();
            },
            child: Text(AppLocalizations.of(context)!.submit),
          ),
        ],
      ),
    );
  }
}

