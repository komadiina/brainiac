import 'package:flutter/material.dart';

import '../../../../util/wordle_key.dart';

@Deprecated("ma daj bjez coece")
class WordleKeyboard extends StatefulWidget {
  const WordleKeyboard({
    super.key,
    required this.qwerty,
    // required this.letterMap,
  });

  final List<List<WordleKey>> qwerty;

  @override
  State<WordleKeyboard> createState() => WordleKeyboardState();
}

class WordleKeyboardState extends State<WordleKeyboard> {
  Map<String, Set<String>> letterMap = {
    'correct': {},
    'present': {},
    'absent': {},
  };

  void updateLetterMap(Map<String, Set<String>> newMap) {
    setState(() {
      letterMap = newMap;
    });
  }

  Color _getKeyColor(String letter) {
    if (letterMap['correct']!.contains(letter)) {
      return Colors.green.withAlpha(180);
    } else if (letterMap['present']!.contains(letter)) {
      return Colors.yellow.withAlpha(180);
    } else if (letterMap['absent']!.contains(letter)) {
      return Colors.black26;
    } else {
      return Colors.grey; // Unknown
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) => Column(
        children: widget.qwerty
            .map(
              (keyRow) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: keyRow
                      .map(
                        (key) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: GestureDetector(
                            onTap: key.onPressed,
                            child: Container(
                              width: orientation == Orientation.portrait
                                  ? 30
                                  : 40,
                              height: orientation == Orientation.portrait
                                  ? 40
                                  : 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: _getKeyColor(key.letter),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.black26),
                              ),
                              child: Text(
                                key.letter,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
