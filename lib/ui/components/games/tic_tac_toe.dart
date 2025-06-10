import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mozgalica/state/config_state.dart';
import 'package:mozgalica/ui/components/animated_fade_scale.dart';
import 'package:mozgalica/ui/components/games/tictactoe/tic_tac_toe_cell.dart';
import 'package:mozgalica/util/coordinate.dart';
import 'package:mozgalica/util/pipe/tic_tac_toe_pipe.dart';
import 'package:mozgalica/util/util.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../util/tic_tac_toe_move.dart';

typedef TicTacToeGrid = List<List<TicTacToeMove>>;

final int inProgress = -1;
final int drawn = 0;
final int playerWon = 1;
final int cpuWon = 2;

class TicTacToeGame extends StatefulWidget {
  const TicTacToeGame({super.key});

  @override
  State<TicTacToeGame> createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  final bool _playerStarts = Random().nextBool();
  TicTacToeMove currentMove = TicTacToeMove.X;
  int _gameStatus = inProgress;
  TicTacToeGrid _grid = generateGrid();
  int _moveCounter = 0;

  @override
  void initState() {
    super.initState();
    if (!_playerStarts) {
      setState(() {
        _grid = cpuNextMove(_grid, currentMove);
        currentMove = currentMove == TicTacToeMove.X
            ? TicTacToeMove.O
            : TicTacToeMove.X;
      });
    }
  }

  void _onTapHelper(int cellIndex) {
    if (_gameStatus != inProgress) {
      return;
    }

    _moveCounter++;

    try {
      // 1. igrac igra potez (onTap)
      var newGrid = updateGridCell(_grid, cellIndex, currentMove);
      var gameStatus = _gameStatus;

      // 2. ako je moveCounter >= 3 provjerava se status
      if (_moveCounter >= 3) {
        gameStatus = checkGrid(
          newGrid,
          _playerStarts ? TicTacToeMove.X : TicTacToeMove.O,
        );
      }

      // setState()
      setState(() {
        _grid = newGrid;
        _gameStatus = gameStatus;
      });

      // 3. ako je inProgress, nastavlja se
      if (gameStatus == inProgress) {
        // cpu igra potez
        newGrid = cpuNextMove(newGrid, nextMove(currentMove));

        // 4. ako je moveCounter >= 3 provjerava se status
        if (_moveCounter >= 3) {
          gameStatus = checkGrid(
            newGrid,
            _playerStarts ? TicTacToeMove.X : TicTacToeMove.O,
          );
        }

        // setState()
        setState(() {
          _grid = newGrid;
          _gameStatus = gameStatus;
        });
      }
    } catch (e) {
      // grid occupied
      // TODO: some haptic or color idk
    }
  }

  void _gameEndHelper(BuildContext context) {
    int maxMoves = (9 / 2).ceil();
    double score = 0;
    switch (_gameStatus) {
      case 0:
        // drawn
        score = 50.0;
      case 1:
        // lost
        score = (50.0 * (_moveCounter / maxMoves));
      case 2:
        // won
        score = (100.0 * (maxMoves - _moveCounter + 1));
    }

    Future.wait([Utilities.gameFinishDialog(context, score, 'tic-tac-toe')]);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        int cellIndexCounter = 0;
        if (_gameStatus != inProgress) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _gameEndHelper(context);
          });
        }

        return Consumer<ConfigurationsState>(
          builder: (context, config, child) => AnimatedFadeScale(
            delay: config.animationDuration,
            duration: config.animationDuration,
            child: OrientationBuilder(
              builder: (context, orientation) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        '${AppLocalizations.of(context)!.ticTacToeYouAre}: ${TicTacToePipe.cellTextPipe(currentMove)}',
                        style: GoogleFonts.roboto(fontSize: 18.0),
                      ),
                    ),
                    Visibility(
                      visible: _playerStarts && _gameStatus == inProgress,
                      child: Text(
                        AppLocalizations.of(context)!.yourTurn,
                        style: GoogleFonts.roboto(fontSize: 18.0),
                      ),
                    ),

                    const SizedBox(height: 12.0),

                    ..._grid.map(
                      (row) => Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...row.map((cell) {
                            int temp = cellIndexCounter++;
                            return TicTacToeCell(
                              cellIndex: temp,
                              cellContent: cell,
                              enabled: _gameStatus == inProgress,
                              onTap: (cellIndex) {
                                _onTapHelper(cellIndex);
                              },
                            );
                          }),
                        ],
                      ),
                    ),

                    Visibility(
                      visible: _gameStatus != inProgress,
                      child: Text(
                        AppLocalizations.of(context)!.ticTacToeGameOver,
                        style: GoogleFonts.roboto(fontStyle: FontStyle.italic),
                      ),
                    ),

                    const SizedBox(height: 12.0),

                    Visibility(
                      visible: _gameStatus == playerWon,
                      child: Text(
                        AppLocalizations.of(context)!.youWon,
                        style: GoogleFonts.roboto(
                          fontStyle: FontStyle.italic,
                          color: Colors.lightGreen,
                        ),
                      ),
                    ),

                    Visibility(
                      visible: _gameStatus == cpuWon,
                      child: Text(
                        AppLocalizations.of(context)!.ticTacToeCpuWon,
                        style: GoogleFonts.roboto(
                          fontStyle: FontStyle.italic,
                          color: Colors.redAccent,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

TicTacToeGrid cpuNextMove(TicTacToeGrid grid, TicTacToeMove move) {
  Set<Coordinate> coordinates = {};

  for (int i = 0; i < grid.length; i++) {
    for (int j = 0; j < grid[i].length; j++) {
      if (grid[i][j] == TicTacToeMove.none) {
        coordinates.add(Coordinate(x: j, y: i));
      }
    }
  }

  Coordinate randomMove = coordinates.elementAt(
    Random().nextInt(coordinates.length),
  );

  grid[randomMove.y][randomMove.x] = move;
  return grid;
}

TicTacToeGrid generateGrid() {
  return List.generate(
    3,
    (_) => List.generate(3, (cellIndex) => TicTacToeMove.none),
  );
}

TicTacToeGrid updateGridCell(
  TicTacToeGrid grid,
  int cellIndex,
  TicTacToeMove move,
) {
  int i = (cellIndex / 3).floor();
  int j = cellIndex % 3;

  if (grid[i][j] != TicTacToeMove.none) {
    throw Exception("cell occupied");
  }

  grid[i][j] = move;

  return grid;
}

TicTacToeMove nextMove(TicTacToeMove move) {
  return move == TicTacToeMove.X ? TicTacToeMove.O : TicTacToeMove.X;
}

// Checks the grid for a possible win
// -1 - in progress
//  0 - draw
//  1 - player won
//  2 - cpu won
// ideja - koristenje sume (poslije mzd)
int checkGrid(TicTacToeGrid grid, TicTacToeMove playerSign) {
  // check if there are any empty cells
  int numEmptyCells = grid
      .expand((row) => row)
      .where((cell) => cell == TicTacToeMove.none)
      .length;

  // no combinations can be made with more than 5 empty cells
  if (numEmptyCells > 5) {
    return inProgress;
  }

  TicTacToeMove sign = TicTacToeMove.none;
  bool completed = true;

  // check rows
  for (int i = 0; i < grid.length; i++) {
    completed = true;
    sign = grid[i][0];

    for (var cell in (grid[i])) {
      if (cell == TicTacToeMove.none) {
        completed = false;
        break;
      }

      completed = completed && (cell == sign);

      if (!completed) {
        break;
      }
    }

    if (completed && sign == playerSign) {
      return playerWon;
    } else if (completed && sign != playerSign) {
      return cpuWon;
    }
  }

  // check cols
  for (int i = 0; i < grid.length; i++) {
    completed = true;
    sign = grid[0][i];

    for (int j = 0; j < grid[i].length; j++) {
      if (grid[j][i] == TicTacToeMove.none) {
        completed = false;
        break;
      }

      completed = completed && (grid[j][i] == sign);

      if (!completed) {
        break;
      }
    }

    if (completed && sign == playerSign) {
      return playerWon;
    } else if (completed && sign != playerSign) {
      return cpuWon;
    }
  }

  // check diagonals
  sign = grid[0][0];
  completed = sign != TicTacToeMove.none;
  for (int i = 0; i < grid.length; i++) {
    completed = completed && (grid[i][i] == sign);
  }
  if (completed && sign == playerSign) {
    return playerWon;
  } else if (completed && sign != playerSign) {
    return cpuWon;
  }

  sign = grid[2][0];
  completed = sign != TicTacToeMove.none;
  for (int i = grid.length - 1, j = 0; i >= 0; i--, j++) {
    completed = completed && (grid[j][i] == sign);
  }
  if (completed && sign == playerSign) {
    return playerWon;
  } else if (completed && sign != playerSign) {
    return cpuWon;
  }

  if (numEmptyCells == 0) {
    return drawn;
  }

  return inProgress;
}
