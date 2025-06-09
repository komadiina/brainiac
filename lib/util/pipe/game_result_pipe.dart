import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mozgalica/db/model/game_result.dart';
import 'package:mozgalica/util/util.dart';

import '../../l10n/app_localizations.dart';

class GameResultPipe {
  static Map<String, Object> leaderboardPipe(GameResult object) {
    return {
      'id': object.id ?? 0,
      'username': object.username == '' ? 'Anonymous' : object.username,
      'gameName': object.gameName.replaceRange(
        0,
        1,
        object.gameName[0].toUpperCase(),
      ),
      'score': object.score.toStringAsFixed(2),
      'dateTime': DateFormat("dd/mm/YYYY").format(object.dateTime),
    };
  }

  static List<Map<String, Object>> leaderboardPipeAll(List<GameResult> object) {
    return object.map((o) => leaderboardPipe(o)).toList();
  }

  static Map<String, Object> translate(
    BuildContext context,
    Map<String, Object> piped,
  ) {
    piped['gameName'] = (piped['gameName']! as String).replaceAll(
      RegExp("[1-9-_=-]"),
      "",
    );

    return {
      ...piped,
      'gameName': Utilities.gameNameLookupMap[piped['gameName']! as String]!
          .call(AppLocalizations.of(context)!),
    };
  }
}
