import "dart:convert";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

class NerdleService {
  static List<String> initialised = [];

  static Future<List<String>> getEquations({limit = -1}) async {
    if (initialised.isEmpty) {
      final String filePath = await rootBundle.loadString(
        'assets/games/equations.json',
      );
      List<dynamic> data = await json.decode(filePath);
      initialised = data.map((e) => e.toString()).toList();
    }

    initialised.shuffle();

    debugPrint(initialised.toString());

    return limit == -1
        ? initialised
        : initialised.getRange(0, limit).toList();
  }
}
