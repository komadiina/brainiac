import "dart:convert";
import "package:flutter/services.dart";

class WordleService {
  static String locale = 'en';
  static Map<String, List<String>> initialised = {};

  static Future<List<String>> getWords({limit = -1}) async {
    if (initialised.isEmpty) {
      final String filePath = await rootBundle.loadString(
        'assets/games/words.json',
      );
      Map<String, dynamic> data = await json.decode(filePath);
      initialised = data.map((k, v) => MapEntry(k, List<String>.from(v)));
    }

    initialised[locale]!.shuffle();

    return limit == -1
        ? initialised[locale]!
        : initialised[locale]!.getRange(0, limit).toList();
  }
}
