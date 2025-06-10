import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_sr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('sr'),
  ];

  /// No description provided for @en.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get en;

  /// No description provided for @sr.
  ///
  /// In en, this message translates to:
  /// **'Serbian'**
  String get sr;

  /// No description provided for @homePage.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homePage;

  /// No description provided for @rankPage.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get rankPage;

  /// No description provided for @settingsPage.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsPage;

  /// No description provided for @homePageNavigationLabel.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homePageNavigationLabel;

  /// No description provided for @leaderboardPageNavigationLabel.
  ///
  /// In en, this message translates to:
  /// **'Rank'**
  String get leaderboardPageNavigationLabel;

  /// No description provided for @settingsPageNavigationLabel.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsPageNavigationLabel;

  /// No description provided for @darkThemeSelected.
  ///
  /// In en, this message translates to:
  /// **'Dark theme'**
  String get darkThemeSelected;

  /// No description provided for @selectedLanguage.
  ///
  /// In en, this message translates to:
  /// **'Selected language'**
  String get selectedLanguage;

  /// No description provided for @animationIntensity.
  ///
  /// In en, this message translates to:
  /// **'Animation intensity'**
  String get animationIntensity;

  /// No description provided for @durationInstant.
  ///
  /// In en, this message translates to:
  /// **'Instant'**
  String get durationInstant;

  /// No description provided for @durationFast.
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get durationFast;

  /// No description provided for @durationNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get durationNormal;

  /// No description provided for @durationSlow.
  ///
  /// In en, this message translates to:
  /// **'Slow'**
  String get durationSlow;

  /// No description provided for @wordleGameTitle.
  ///
  /// In en, this message translates to:
  /// **'Wordle'**
  String get wordleGameTitle;

  /// No description provided for @wordleGameDescription.
  ///
  /// In en, this message translates to:
  /// **'NY Times classic!'**
  String get wordleGameDescription;

  /// No description provided for @ticTacToeGameTitle.
  ///
  /// In en, this message translates to:
  /// **'Tic-Tac-Toe'**
  String get ticTacToeGameTitle;

  /// No description provided for @ticTacToeGameDescription.
  ///
  /// In en, this message translates to:
  /// **'A classical tic-tac-toe game against a CPU.'**
  String get ticTacToeGameDescription;

  /// No description provided for @mathQuizGameTitle.
  ///
  /// In en, this message translates to:
  /// **'Nerdle'**
  String get mathQuizGameTitle;

  /// No description provided for @mathQuizGameDescription.
  ///
  /// In en, this message translates to:
  /// **'Nerdle, but easier...'**
  String get mathQuizGameDescription;

  /// No description provided for @youGuessedIt.
  ///
  /// In en, this message translates to:
  /// **'🎉 You guessed it!'**
  String get youGuessedIt;

  /// No description provided for @wordleGameOver.
  ///
  /// In en, this message translates to:
  /// **'☹️ Game over... Word was: '**
  String get wordleGameOver;

  /// No description provided for @pleaseEnterUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter Your player name'**
  String get pleaseEnterUsername;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @usernameHeaderColumnText.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameHeaderColumnText;

  /// No description provided for @gameNameHeaderColumnText.
  ///
  /// In en, this message translates to:
  /// **'Game'**
  String get gameNameHeaderColumnText;

  /// No description provided for @scoreHeaderColumnText.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get scoreHeaderColumnText;

  /// No description provided for @dateTimeHeaderColumnText.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateTimeHeaderColumnText;

  /// No description provided for @usernameFilterHintText.
  ///
  /// In en, this message translates to:
  /// **'Player...'**
  String get usernameFilterHintText;

  /// No description provided for @scoreFilterHintText.
  ///
  /// In en, this message translates to:
  /// **'Score...'**
  String get scoreFilterHintText;

  /// No description provided for @gameNameFilterHintText.
  ///
  /// In en, this message translates to:
  /// **'Game...'**
  String get gameNameFilterHintText;

  /// No description provided for @noDataToDisplay.
  ///
  /// In en, this message translates to:
  /// **'No results to show.'**
  String get noDataToDisplay;

  /// No description provided for @allGames.
  ///
  /// In en, this message translates to:
  /// **'All games'**
  String get allGames;

  /// No description provided for @tictactoe.
  ///
  /// In en, this message translates to:
  /// **'Tic-tac-toe'**
  String get tictactoe;

  /// No description provided for @wordle.
  ///
  /// In en, this message translates to:
  /// **'Wordle'**
  String get wordle;

  /// No description provided for @nerdle.
  ///
  /// In en, this message translates to:
  /// **'Nerdle'**
  String get nerdle;

  /// No description provided for @yourTurn.
  ///
  /// In en, this message translates to:
  /// **'Your turn!'**
  String get yourTurn;

  /// No description provided for @ticTacToeYouAre.
  ///
  /// In en, this message translates to:
  /// **'Playing as'**
  String get ticTacToeYouAre;

  /// No description provided for @gameMotto.
  ///
  /// In en, this message translates to:
  /// **'A mini-game a day keeps the doctor away!'**
  String get gameMotto;

  /// No description provided for @gameMottoHeader.
  ///
  /// In en, this message translates to:
  /// **'Try some of our hand-picked games for you!'**
  String get gameMottoHeader;

  /// No description provided for @youWon.
  ///
  /// In en, this message translates to:
  /// **'You won!'**
  String get youWon;

  /// No description provided for @ticTacToeGameOver.
  ///
  /// In en, this message translates to:
  /// **'Game over.'**
  String get ticTacToeGameOver;

  /// No description provided for @ticTacToeCpuWon.
  ///
  /// In en, this message translates to:
  /// **'CPU won... Really?'**
  String get ticTacToeCpuWon;

  /// No description provided for @correct.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get correct;

  /// No description provided for @present.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get present;

  /// No description provided for @absent.
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get absent;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'sr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'sr':
      return AppLocalizationsSr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
