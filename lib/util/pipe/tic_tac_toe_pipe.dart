import 'package:mozgalica/util/tic_tac_toe_move.dart';

class TicTacToePipe {
  static String cellTextPipe(TicTacToeMove move) {
    switch (move) {
      case TicTacToeMove.X:
        return 'X';
      case TicTacToeMove.O:
        return 'O';
      default:
        return '';
    }
  }
}