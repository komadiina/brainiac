// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Serbian (`sr`).
class AppLocalizationsSr extends AppLocalizations {
  AppLocalizationsSr([String locale = 'sr']) : super(locale);

  @override
  String get en => 'Engleski';

  @override
  String get sr => 'Srpski';

  @override
  String get homePage => 'Početna';

  @override
  String get rankPage => 'Rezultati';

  @override
  String get settingsPage => 'Podešavanja';

  @override
  String get homePageNavigationLabel => 'Početna';

  @override
  String get leaderboardPageNavigationLabel => 'Statistika';

  @override
  String get settingsPageNavigationLabel => 'Podešavanja';

  @override
  String get darkThemeSelected => 'Tamna tema';

  @override
  String get selectedLanguage => 'Odabrani jezik';

  @override
  String get animationIntensity => 'Intenzitet animacija';

  @override
  String get durationInstant => 'Bez animacija';

  @override
  String get durationFast => 'Brzo';

  @override
  String get durationNormal => 'Uobičajeno';

  @override
  String get durationSlow => 'Sporo';

  @override
  String get wordleGameTitle => 'Wordle';

  @override
  String get wordleGameDescription =>
      'Zabavna igra nagađanja riječi - NY Times hit!';

  @override
  String get ticTacToeGameTitle => 'Iks-Oks';

  @override
  String get ticTacToeGameDescription => 'Klasičan iks-oks protiv računara.';

  @override
  String get mathQuizGameTitle => 'Matematičarko';

  @override
  String get mathQuizGameDescription => 'Nerdle, ali lakši...';

  @override
  String get youGuessedIt => '🎉 Pogodili ste!';

  @override
  String get wordleGameOver => '☹️ Kraj... Riječ je: ';

  @override
  String get pleaseEnterUsername => 'Unesite vaše korisničko ime';

  @override
  String get submit => 'Sačuvajte';

  @override
  String get usernameHeaderColumnText => 'Korisnik';

  @override
  String get gameNameHeaderColumnText => 'Igra';

  @override
  String get scoreHeaderColumnText => 'Rezultat';

  @override
  String get dateTimeHeaderColumnText => 'Datum';

  @override
  String get usernameFilterHintText => 'Igrač...';

  @override
  String get scoreFilterHintText => 'Rezultat...';

  @override
  String get gameNameFilterHintText => 'Igra...';

  @override
  String get noDataToDisplay => 'Nema podataka.';

  @override
  String get allGames => 'Sve igre';

  @override
  String get tictactoe => 'Tic-tac-toe';

  @override
  String get wordle => 'Wordle';

  @override
  String get nerdle => 'Nerdle';
}
