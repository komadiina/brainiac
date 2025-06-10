import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mozgalica/l10n/app_localizations.dart';
import 'package:mozgalica/resources/configurations/navigation.dart';
import 'package:mozgalica/resources/configurations/variables.dart';
import 'package:mozgalica/state/config_state.dart';
import 'package:mozgalica/ui/components/animated_fade_scale.dart';
import 'package:mozgalica/ui/components/game_banner.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, bool> visible = {
    'wordle': false,
    'tic-tac-toe': false,
    'nerdle': false,
  };

  late Duration? fadeInDuration;
  late Duration? scaleInDuration;
  final double beginOpacity = 0.0;
  final double endOpacity = 1.0;
  final double beginScale = 0.85;
  final double endScale = 1.0;

  Future<void> fadeIn() async {
    for (final key in visible.keys) {
      await Future.delayed(const Duration(milliseconds: 150));
      if (mounted) {
        setState(() {
          visible[key] = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fadeIn();
  }

  @override
  Widget build(BuildContext context) {
    int animationDurationMillis = Provider.of<ConfigurationsState>(
      context,
      listen: false,
    ).animationDuration.inMilliseconds;

    fadeInDuration = Duration(
      milliseconds: (animationDurationMillis * cardFadeInFactor).floor(),
    );

    scaleInDuration = Duration(
      milliseconds: (animationDurationMillis * cardFadeInFactor).floor(),
    );

    return OrientationBuilder(
      builder: (context, orientation) {
        return Consumer<ConfigurationsState>(
          builder: (context, config, child) => Flex(
            direction: orientation == Orientation.portrait
                ? Axis.vertical
                : Axis.horizontal,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.gameMottoHeader,
                    style: GoogleFonts.robotoFlex(fontSize: 18.0),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.gameMotto,
                    style: GoogleFonts.robotoFlex(fontSize: 16.0, fontWeight: FontWeight.w300),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: const Divider(),
              ),

              Flexible(
                child: AnimatedFadeScale(
                  delay: config.animationDuration * 0.25,
                  duration: config.animationDuration,
                  child: GameBanner(
                    title: AppLocalizations.of(context)!.ticTacToeGameTitle,
                    description: AppLocalizations.of(
                      context,
                    )!.ticTacToeGameDescription,
                    imageAssetPath: 'assets/games/tic-tac-toe.png',
                    routeName: ticTacToeGameRouteName,
                  ),
                ),
              ),

              Flexible(
                child: AnimatedFadeScale(
                  delay: config.animationDuration * 0.25,
                  duration: config.animationDuration,
                  child: GameBanner(
                    title: AppLocalizations.of(context)!.wordleGameTitle,
                    description: AppLocalizations.of(
                      context,
                    )!.wordleGameDescription,
                    imageAssetPath: 'assets/games/wordle.png',
                    routeName: wordleGameRouteName,
                  ),
                ),
              ),

              Flexible(
                child: AnimatedFadeScale(
                  delay: config.animationDuration * 0.25,
                  duration: config.animationDuration,
                  child: GameBanner(
                    title: AppLocalizations.of(context)!.mathQuizGameTitle,
                    description: AppLocalizations.of(
                      context,
                    )!.mathQuizGameDescription,
                    imageAssetPath: 'assets/games/nerdle.png',
                    routeName: nerdleGameRouteName,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
