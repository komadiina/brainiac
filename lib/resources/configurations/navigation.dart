import 'package:flutter/cupertino.dart';
import 'package:mozgalica/resources/configurations/variables.dart';
import 'package:mozgalica/ui/components/game_component.dart';
import 'package:mozgalica/ui/components/games/nerdle.dart';
import 'package:mozgalica/ui/components/games/tic_tac_toe.dart';
import 'package:mozgalica/ui/components/games/wordle.dart';

const String wordleGameRouteName = "/wordle";
const String ticTacToeGameRouteName = "/tic-tac-toe";
const String nerdleGameRouteName = "/mathy";

Map<String, WidgetBuilder> mozgalicaRoutes = {
  wordleGameRouteName: (BuildContext context) => GameComponent(
    widgetComponent: WordleGame(maxAttempts: maxAttemptsNormal),
  ),
  ticTacToeGameRouteName: (BuildContext context) =>
      GameComponent(widgetComponent: TicTacToeGame()),
  nerdleGameRouteName: (BuildContext context) => GameComponent(
    widgetComponent: NerdleGame(maxAttempts: maxAttemptsNormal),
  ),
};
