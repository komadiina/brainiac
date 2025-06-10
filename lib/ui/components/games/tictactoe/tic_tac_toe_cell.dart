import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mozgalica/util/tic_tac_toe_move.dart';

import '../../../../util/pipe/tic_tac_toe_pipe.dart';

class TicTacToeCell extends StatefulWidget {
  const TicTacToeCell({
    super.key,
    required this.cellIndex,
    required this.cellContent,
    required this.enabled,
    required this.onTap
  });

  final int cellIndex;
  final TicTacToeMove cellContent;
  final bool enabled;
  final void Function(int) onTap;

  @override
  State<TicTacToeCell> createState() => _TicTacToeCellState();
}

class _TicTacToeCellState extends State<TicTacToeCell> {
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) => InkWell(
        enableFeedback: widget.enabled,
        onTap: () { widget.onTap(widget.cellIndex); },
        borderRadius: BorderRadius.circular(12.0),
        child: Card(
          elevation: 1,
          color: Theme.of(
            context,
          ).colorScheme.surfaceContainerHigh,
          child: SizedBox(
            width: orientation == Orientation.portrait
                ? 96
                : 72,
            height: orientation == Orientation.portrait
                ? 96
                : 72,
            child: Center(
              child: Text(
                TicTacToePipe.cellTextPipe(widget.cellContent),
                style: GoogleFonts.roboto(
                  fontSize: 64.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
