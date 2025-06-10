import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mozgalica/db/database_singleton.dart';
import 'package:mozgalica/state/config_state.dart';
import 'package:mozgalica/ui/mozgalica_app.dart';
import 'package:provider/provider.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // kreiranje instance pri pokretanju
  // sqfliteFfiInit();
  await DatabaseSingleton().database;

  // await GameResultRepository.insertAll(db, [
  //   GameResult(id: null, username: 'ognjen', gameName: 'wordle', score: 100.00, dateTime: DateTime.now()),
  //   GameResult(id: null, username: 'ognjen', gameName: 'wordle', score: 50.00, dateTime: DateTime.now()),
  //   GameResult(id: null, username: 'test', gameName: 'tic-tac-toe', score: 100.00, dateTime: DateTime.now()),
  //   GameResult(id: null, username: 'ner', gameName: 'nerdle', score: 100.00, dateTime: DateTime.now()),
  //   GameResult(id: null, username: 'ognjen', gameName: 'wordle', score: 50.00, dateTime: DateTime.now()),
  // ]);

  // inicijalizacija lokalizacije
  // TranslationService.init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ConfigurationsState()),
      ],
      child: const MozgalicaApp(),
    ),
  );
}
