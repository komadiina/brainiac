import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mozgalica/services/nerdle_service.dart';
import 'package:mozgalica/util/wordle_guess.dart';

import '../../../l10n/app_localizations.dart';
import '../../../resources/configurations/variables.dart';
import '../../../util/util.dart';

class NerdleGame extends StatefulWidget {
  const NerdleGame({super.key, required this.maxAttempts});

  final int maxAttempts;

  @override
  State<NerdleGame> createState() => _NerdleGameState();
}

class _NerdleGameState extends State<NerdleGame> {
  static const int wordLength = 9;

  final FocusNode _focusNode = FocusNode(); // keyboardListener attachment node
  late List<String> equationList = [];
  late String answer = "";
  List<String> guesses = [];
  String currentGuess = "";
  Map<String, Set<String>> numberMap = {
    "correct": {},
    "present": {},
    "absent": {},
    "unknown": Set.of(numericSymbolList),
  };

  final Future<List<String>> _fetchEquations = Future<List<String>>(() async {
    return await NerdleService.getEquations();
  });

  void _refreshLetters(String guess, List<WordleGuess> result) {
    final updatedLetterMap = {
      "correct": {...numberMap['correct']!},
      "present": {...numberMap['present']!},
      "absent": {...numberMap['absent']!},
      "unknown": {...numberMap['unknown']!},
    };

    for (int i = 0; i < guess.length; i++) {
      String letter = guess[i];
      WordleGuess status = result[i];

      switch (status) {
        case WordleGuess.correct:
          updatedLetterMap['correct']!.add(letter);
          updatedLetterMap['unknown']!.remove(letter);
          break;
        case WordleGuess.present:
          updatedLetterMap['present']!.add(letter);
          updatedLetterMap['unknown']!.remove(letter);
          break;
        case WordleGuess.absent:
          updatedLetterMap['absent']!.add(letter);
          updatedLetterMap['unknown']!.remove(letter);
          break;
      }
    }

    setState(() {
      numberMap = updatedLetterMap;
    });
  }

  void _onEnterPressed() {
    if (currentGuess.length == answer.length) {
      setState(() {
        guesses.add(currentGuess.toLowerCase());
        _refreshLetters(guesses.last, getGuess(guesses.last, 0));
        currentGuess = "";
      });
    }
  }

  void _onCharacterDeleted() {
    if (currentGuess.isNotEmpty) {
      setState(() {
        currentGuess = currentGuess.substring(0, currentGuess.length - 1);
      });
    }
  }

  void _onSymbolInput(String keyLabel) {
    if (keyLabel.length == 1 &&
        !RegExp(r'^[a-zA-Z]$').hasMatch(keyLabel) &&
        currentGuess.length < wordLength) {
      setState(() {
        currentGuess = '$currentGuess$keyLabel';
      });
    }
  }

  KeyEventResult _handleKeyPress(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.enter:
          _onEnterPressed();
          return KeyEventResult.handled;

        case LogicalKeyboardKey.delete || LogicalKeyboardKey.backspace:
          _onCharacterDeleted();
          return KeyEventResult.handled;

        default:
          _onSymbolInput(event.logicalKey.keyLabel);
          return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }

  List<WordleGuess> getGuess(String guess, int index) {
    final int length = answer.length;

    final List<WordleGuess> statuses = List<WordleGuess>.filled(
      length,
      WordleGuess.absent,
    );
    final List<String> splitSolution = answer.split('');
    final List<String> splitGuess = guess.split('');
    final List<bool> solutionCharsTaken = List<bool>.filled(length, false);

    // Step 1: Mark correct characters
    for (int i = 0; i < length; i++) {
      if (splitGuess[i].toLowerCase() == splitSolution[i].toLowerCase()) {
        statuses[i] = WordleGuess.correct;
        solutionCharsTaken[i] = true;
      }
    }

    // Step 2: Mark present or absent characters
    for (int i = 0; i < length; i++) {
      if (statuses[i] == WordleGuess.correct) {
        continue; // Already marked as correct
      }

      final ch = splitGuess[i];

      // If the character is not in solution at all
      if (!splitSolution.contains(ch)) {
        statuses[i] = WordleGuess.absent;
        continue;
      }

      // Try to find a non-taken matching character
      bool found = false;
      for (int j = 0; j < length; j++) {
        if (splitSolution[j].toLowerCase() == ch.toLowerCase() &&
            !solutionCharsTaken[j]) {
          statuses[i] = WordleGuess.present;
          solutionCharsTaken[j] = true;
          found = true;
          break;
        }
      }

      if (!found) {
        statuses[i] = WordleGuess.absent;
      }
    }

    return statuses;
  }

  Color getTileColor(String guess, int index) {
    final List<WordleGuess> statuses = getGuess(guess, index);

    switch (statuses.elementAt(index)) {
      case WordleGuess.correct:
        return Colors.green.withAlpha(100);
      case WordleGuess.present:
        return Colors.yellow.withAlpha(100);
      case WordleGuess.absent:
        return Colors.black45;
    }
  }

  Widget buildTile(
    String char,
    Orientation orientation, {
    Color color = Colors.grey,
  }) {
    return Container(
      margin: const EdgeInsets.all(4),
      width: orientation == Orientation.portrait ? 32 : 64,
      height: orientation == Orientation.portrait ? 32 : 64,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: Text(
        char.toUpperCase(),
        style: const TextStyle(
          fontSize: 24,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildRow(String guess, Orientation orientation) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(wordLength, (i) {
        final char = guess[i];
        final color = getTileColor(guess, i);
        return buildTile(char, orientation, color: color);
      }),
    );
  }

  List<Widget> buildPreviousGuesses(
    Orientation orientation, {
    Color absentColor = Colors.black12,
  }) {
    return guesses.map((guess) => buildRow(guess, orientation)).toList();
  }

  Widget buildEmptyRow(Color color, Orientation orientation) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(wordLength, (i) {
        String char = i < currentGuess.length ? currentGuess[i] : '';
        return buildTile(char, orientation, color: color);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool guessed = guesses.contains(answer);
    bool lost = guesses.length >= widget.maxAttempts;
    bool isGameOver = guessed || lost;

    return FutureBuilder(
      future: _fetchEquations,
      builder: (context, asyncSnapshot) {
        debugPrint(asyncSnapshot.toString());

        _focusNode.requestFocus();
        equationList = asyncSnapshot.data ?? [];

        if (equationList.isEmpty) {
          return Center(child: const CircularProgressIndicator());
        }

        if (asyncSnapshot.hasData) {
          answer = equationList.elementAt(0);
          // debugPrint('answer: $answer');

          if (guessed) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Utilities.gameFinishDialog(
                context,
                ((widget.maxAttempts - guesses.length + 1) /
                        (widget.maxAttempts)) *
                    100.0,
                'nerdle',
              );
            });
          } else if (lost) {
            Utilities.gameFinishDialog(context, 0.00, 'nerdle');
          }

          // SystemChannels.textInput.invokeMethod("TextInput.show");

          return KeyboardListener(
            focusNode: _focusNode,
            onKeyEvent: (event) {
              _handleKeyPress(_focusNode, event);
            },
            child: SingleChildScrollView(
              child: OrientationBuilder(
                builder: (context, orientation) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.mathQuizGameTitle,
                            style: const TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),

                      if (guesses.isNotEmpty)
                        ...buildPreviousGuesses(
                          orientation,
                          absentColor: Theme.of(
                            context,
                          ).colorScheme.inversePrimary.withAlpha(100),
                        ),

                      if (!isGameOver && guesses.length < widget.maxAttempts)
                        buildEmptyRow(
                          Theme.of(context).colorScheme.inversePrimary,
                          orientation,
                        ),

                      for (
                        int i = guesses.length + 1;
                        i < widget.maxAttempts;
                        i++
                      )
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            wordLength,
                            (_) => buildTile(
                              '',
                              orientation,
                              color: Theme.of(
                                context,
                              ).colorScheme.inverseSurface.withAlpha(20),
                            ),
                          ),
                        ),

                      if (isGameOver)
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Center(
                            child: Text(
                              guesses.contains(answer)
                                  ? AppLocalizations.of(context)!.youGuessedIt
                                  : "${AppLocalizations.of(context)!.wordleGameOver}$answer",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                      Wrap(
                        children: [
                          ...'12345'
                              .split('')
                              .map(
                                (number) => GestureDetector(
                                  onTap: () {
                                    _onSymbolInput(number);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Chip(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .inverseSurface
                                          .withAlpha(15),
                                      padding: EdgeInsets.all(12),
                                      label: Text(
                                        number,
                                        // textScaler: TextScaler.linear(1.5),
                                        style: const TextStyle(fontSize: 24),
                                      ),
                                      visualDensity: VisualDensity.comfortable,
                                    ),
                                  ),
                                ),
                              ),
                        ],
                      ),

                      Wrap(
                        children: [
                          ...'67890'
                              .split('')
                              .map(
                                (number) => GestureDetector(
                                  onTap: () {
                                    _onSymbolInput(number);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Chip(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .inverseSurface
                                          .withAlpha(15),
                                      padding: EdgeInsets.all(12),
                                      label: Text(
                                        number,
                                        // textScaler: TextScaler.linear(1.5),
                                        style: const TextStyle(fontSize: 24),
                                      ),
                                      visualDensity: VisualDensity.comfortable,
                                    ),
                                  ),
                                ),
                              ),
                        ],
                      ),

                      Wrap(
                        children: [
                          ...'+-*/='
                              .split('')
                              .map(
                                (number) => GestureDetector(
                                  onTap: () {
                                    _onSymbolInput(number);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Chip(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .inverseSurface
                                          .withAlpha(15),
                                      padding: EdgeInsets.all(12),
                                      label: Text(
                                        number,
                                        // textScaler: TextScaler.linear(2),
                                        style: const TextStyle(fontSize: 24),
                                      ),
                                      visualDensity: VisualDensity.comfortable,
                                    ),
                                  ),
                                ),
                              ),
                        ],
                      ),

                      Wrap(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _onCharacterDeleted();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Chip(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface
                                    .withAlpha(15),
                                padding: EdgeInsets.all(12),
                                label: Text(
                                  "DELETE",
                                  // textScaler: TextScaler.linear(2),
                                  style: const TextStyle(fontSize: 24),
                                ),
                                visualDensity: VisualDensity.comfortable,
                              ),
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              _onEnterPressed();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Chip(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface
                                    .withAlpha(15),
                                padding: EdgeInsets.all(12),
                                label: Text(
                                  "ENTER",
                                  // textScaler: TextScaler.linear(2),
                                  style: const TextStyle(fontSize: 24),
                                ),
                                visualDensity: VisualDensity.comfortable,
                              ),
                            ),
                          ),
                        ],
                      )

                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: numberMap.entries.map((entry) {
                      //     return Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text(
                      //           entry.key.toUpperCase(),
                      //           style: const TextStyle(
                      //             fontSize: 18,
                      //             fontWeight: FontWeight.bold,
                      //           ),
                      //         ),
                      //         Wrap(
                      //           spacing: 8,
                      //           children: entry.value.map((letter) {
                      //             return Chip(
                      //               label: Text(
                      //                 letter,
                      //                 style: const TextStyle(
                      //                   fontSize: 16,
                      //                   fontWeight: FontWeight.bold,
                      //                 ),
                      //               ),
                      //               backgroundColor: _getColor(entry.key),
                      //             );
                      //           }).toList(),
                      //         ),
                      //         const SizedBox(height: 16),
                      //       ],
                      //     );
                      //   }).toList(),
                      // ),
                    ],
                  );
                },
              ),
            ),
          );
        } else if (asyncSnapshot.hasError) {
          return Placeholder(child: Text(asyncSnapshot.error.toString()));
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    // SystemChannels.textInput.invokeMethod("TextInput.hide");
    super.dispose();
  }
}
