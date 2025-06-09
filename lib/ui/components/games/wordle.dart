
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mozgalica/l10n/app_localizations.dart';
import 'package:mozgalica/resources/configurations/variables.dart';
import 'package:mozgalica/services/wordle_service.dart';
import 'package:mozgalica/util/util.dart';
import 'package:mozgalica/util/wordle_guess.dart';


class WordleGame extends StatefulWidget {
  const WordleGame({super.key, required this.maxAttempts});

  final int maxAttempts;

  @override
  State<WordleGame> createState() => _WordleGameState();
}

class _WordleGameState extends State<WordleGame> {
  static const int wordLength = 5;

  final FocusNode _focusNode = FocusNode(); // keyboardListener attachment node
  late List<String> wordList = [];
  late String answer = "";
  List<String> guesses = [];
  String currentGuess = "";
  Map<String, Set<String>> letterMap = {
    "correct": {},
    "present": {},
    "absent": {},
    "unknown": Set.of(alphabetList),
  };

  final Future<List<String>> _fetchWords = Future<List<String>>.delayed(
    const Duration(milliseconds: 350),
    () async {
      return await WordleService.getWords(limit: 15);
    },
  );

  void _refreshLetters(String guess, List<WordleGuess> result) {
    final updatedLetterMap = {
      "correct": {...letterMap['correct']!},
      "present": {...letterMap['present']!},
      "absent": {...letterMap['absent']!},
      "unknown": {...letterMap['unknown']!},
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
      letterMap = updatedLetterMap;
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

  void _onLetterInput(String keyLabel) {
    if (keyLabel.length == 1 &&
        RegExp(r'^[a-zA-Z]$').hasMatch(keyLabel) &&
        currentGuess.length < 5) {
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
          _onLetterInput(event.logicalKey.keyLabel);
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

  Color _getColor(String state) {
    switch (state) {
      case 'correct':
        return Colors.green.withAlpha(100);
      case 'present':
        return Colors.yellow.withAlpha(100);
      case 'absent':
        return Colors.black45;
      default:
        return Colors.grey;
    }
  }

  Widget buildTile(
    String char,
    Orientation orientation, {
    Color color = Colors.grey,
  }) {
    return Container(
      margin: const EdgeInsets.all(4),
      width: orientation == Orientation.portrait ? 48 : 96,
      height: orientation == Orientation.portrait ? 48 : 96,
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
      future: _fetchWords,
      builder: (context, asyncSnapshot) {
        _focusNode.requestFocus();
        wordList = asyncSnapshot.data ?? [];

        if (wordList.isEmpty) {
          return Center(child: const CircularProgressIndicator());
        }

        if (asyncSnapshot.hasData) {
          answer = wordList.elementAt(0);
          // debugPrint('answer: $answer');

          if (guessed) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Utilities.gameFinishDialog(
                context,
                ((widget.maxAttempts - guesses.length + 1) /
                        (widget.maxAttempts)) *
                    100.0,
                'wordle',
              );
            });
          } else if (lost) {
            Utilities.gameFinishDialog(context, 0.00, 'wordle');
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
                        child: const Center(
                          child: Text(
                            'Wordle',
                            style: TextStyle(
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

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: letterMap.entries.map((entry) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.key.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Wrap(
                                spacing: 8,
                                children: entry.value.map((letter) {
                                  return Chip(
                                    label: Text(
                                      letter,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    backgroundColor: _getColor(entry.key),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 16),
                            ],
                          );
                        }).toList(),
                      ),
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
