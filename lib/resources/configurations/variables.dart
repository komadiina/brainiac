import 'dart:core';

// ----- Database
final String databaseTableName = "game_result";
final String databaseName = "game_result.db";

// ----- App
final String appTitle = "Mozgalica";


// ----- Animation
final Duration durationInstant = Duration.zero;
final Duration durationFast = const Duration(milliseconds: 150);
final Duration durationNormal = const Duration(milliseconds: 225);
final Duration durationSlow = const Duration(milliseconds: 300);

// ----- Homepage
final double cardFadeInDelayFactor = 0.33;
final double cardFadeInFactor = 1.4;

// ----- Wordle

// ----- Tic-Tac-Toe

// ----- Nerdle
final double gameFadeInFactor = 1.15;


// ----- Wordle
final int maxAttemptsEasy = 8;
final int maxAttemptsNormal = 6;
final int maxAttemptsHard = 4;
final List<String> alphabetList = [
  'a',
  'b',
  'c',
  'd',
  'e',
  'f',
  'g',
  'h',
  'i',
  'j',
  'k',
  'l',
  'm',
  'n',
  'o',
  'p',
  'q',
  'r',
  's',
  't',
  'u',
  'v',
  'w',
  'x',
  'y',
  'z'
];
final List<String> numericSymbolList = [
  "+", "-", "=", "*", "/",
  "1", "2", "3", "4", "5",
  "6", "7", "8", "9", "0"
];