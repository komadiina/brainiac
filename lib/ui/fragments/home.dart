import 'package:flutter/material.dart';
import 'package:mozgalica/l10n/app_localizations.dart';
import 'package:mozgalica/resources/configurations/navigation.dart';
import 'package:mozgalica/ui/components/game_banner.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Flex(
          direction: orientation == Orientation.portrait
              ? Axis.vertical
              : Axis.horizontal,
          children: [
            if (orientation == Orientation.landscape)
              const SizedBox(height: 64.0),
            GameBanner(
              title: AppLocalizations.of(context)!.wordleGameTitle,
              description: AppLocalizations.of(context)!.wordleGameDescription,
              imageAssetPath: 'assets/games/wordle.png',
              routeName: wordleGameRouteName,
            ),

            GameBanner(
              title: AppLocalizations.of(context)!.ticTacToeGameTitle,
              description: AppLocalizations.of(context)!.ticTacToeGameDescription,
              imageAssetPath: 'assets/games/tic-tac-toe.png',
              routeName: ticTacToeGameRouteName,
            ),

            GameBanner(
              title: AppLocalizations.of(context)!.mathQuizGameTitle,
              description: AppLocalizations.of(context)!.mathQuizGameDescription,
              imageAssetPath: 'assets/games/nerdle.png',
              routeName: nerdleGameRouteName,
            ),
          ],
        );
      },
    );
  }
}
