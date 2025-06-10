import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mozgalica/resources/configurations/variables.dart';
import 'package:mozgalica/l10n/app_localizations.dart';
import 'package:mozgalica/services/wordle_service.dart';
import 'package:mozgalica/ui/fragments/home.dart';

import '../resources/configurations/navigation.dart';
import 'fragments/leaderboard.dart';
import 'fragments/settings.dart';

// kontrolisanje teme van MaterialApp component stabla (upotrebom stream-a)
StreamController<bool> themeController = StreamController();

class MozgalicaApp extends StatefulWidget {
  const MozgalicaApp({super.key});

  @override
  State<StatefulWidget> createState() => _MozgalicaAppState();
}

class _MozgalicaAppState extends State<MozgalicaApp> {
  ThemeMode themeMode = ThemeMode.dark;
  final ThemeData themeData = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
  Locale appLocale = Locale('en');
  int currentPageIndex = 0;
  Duration selectedDuration = durationNormal;
  Map<String, Object?> presetValues = {'duration': durationNormal};

  // todo: decouple van MozgalicaApp
  void _onAnimationDurationChanged(Duration duration) {
    setState(() {
      presetValues['duration'] = duration;
      selectedDuration = duration;
    });
  }

  void _onThemeToggled() {
    setState(() {
      themeMode = themeMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  void _onLocaleChanged(String localeKey) {
    setState(() {
      appLocale = Locale(localeKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      HomePage(key: ValueKey(appLocale)),
      LeaderboardPage(key: ValueKey(appLocale)),
      SettingsPage(
        key: ValueKey(appLocale),
        onThemeToggled: _onThemeToggled,
        onLocaleChanged: _onLocaleChanged,
        onAnimationDurationChanged: _onAnimationDurationChanged,
        presetValues: presetValues,
      ),
    ];

    return Builder(
      builder: (context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: appTitle,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          theme: themeData,
          darkTheme: ThemeData.dark(useMaterial3: true),
          locale: appLocale,
          themeMode: themeMode,
          routes: mozgalicaRoutes,
          home: Builder(
            builder: (context) {
              // setup wordle
              WordleService.locale = AppLocalizations.of(context)!.localeName;

              return Scaffold(
                appBar:
                    MediaQuery.of(context).orientation == Orientation.portrait
                    ? AppBar(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.secondary,
                        toolbarHeight: 48,
                        title: Text(
                          appTitle,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                      )
                    : null, // nevidljiv appBar u landscape orijentaciji
                body: AnimatedSwitcher(
                  duration: selectedDuration,
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeOut,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: pages[currentPageIndex],
                ),
                bottomNavigationBar: NavigationBar(
                  animationDuration: selectedDuration,
                  selectedIndex: currentPageIndex,
                  indicatorColor: Theme.of(
                    context,
                  ).colorScheme.inverseSurface.withAlpha(50),
                  onDestinationSelected: (index) {
                    setState(() {
                      currentPageIndex = index;
                    });
                  },
                  labelBehavior:
                      NavigationDestinationLabelBehavior.onlyShowSelected,
                  destinations: <NavigationDestination>[
                    NavigationDestination(
                      selectedIcon: Icon(Icons.home),
                      icon: Icon(Icons.home_outlined),
                      label: AppLocalizations.of(
                        context,
                      )!.homePageNavigationLabel,
                    ),

                    NavigationDestination(
                      selectedIcon: Icon(Icons.leaderboard),
                      icon: Icon(Icons.leaderboard_outlined),
                      label: AppLocalizations.of(
                        context,
                      )!.leaderboardPageNavigationLabel,
                    ),

                    NavigationDestination(
                      selectedIcon: Icon(Icons.settings),
                      icon: Icon(Icons.settings_outlined),
                      label: AppLocalizations.of(
                        context,
                      )!.settingsPageNavigationLabel,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
