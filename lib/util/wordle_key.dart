import 'dart:ui';

class WordleKey {
  const WordleKey({required this.letter, required this.onPressed});

  final String letter;
  final VoidCallback onPressed;
}
