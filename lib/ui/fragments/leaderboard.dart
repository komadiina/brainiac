import 'package:flutter/material.dart';
import 'package:mozgalica/db/database_singleton.dart';
import 'package:mozgalica/db/repository/game_result_repository.dart';
import 'package:mozgalica/l10n/app_localizations.dart';
import 'package:mozgalica/util/pipe/game_result_pipe.dart';

import '../../db/model/game_result.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<StatefulWidget> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  late List<GameResult> _rawData = []; // procesujuci podaci (kesirani)
  late List<GameResult> _filteredRaw = []; // filtrirani podaci
  late List<Map<String, Object>> _presentationData = []; // prezentacioni podaci
  int? _sortColumnIndex;
  bool _sortAscending = true;

  // 0 - no sort, 1 - descending, 2 - ascending
  int _sortCriteriaCounter = 0;

  final TextEditingController _usernameFilterController =
      TextEditingController();
  String _selectedGameName = '';

  @override
  void initState() {
    super.initState();
    _fetchResults();
  }

  Future<void> _fetchResults() async {
    var db = await DatabaseSingleton().database;
    _rawData = await GameResultRepository.getAll(db);

    // debugPrint(_rawData.toString());

    _applyFilters();
  }

  void _applyFilters({bool applySorting = true}) {
    _filteredRaw = _rawData.where((result) {
      final matchesGame =
          _selectedGameName.isEmpty || result.gameName == _selectedGameName;
      final matchesUsername = result.username.toLowerCase().contains(
        _usernameFilterController.text.toLowerCase(),
      );
      return matchesGame && matchesUsername;
    }).toList();

    if (applySorting && _sortColumnIndex != null) {
      _sortData(_sortColumnIndex!, _sortAscending);
    }

    setState(() {
      _presentationData = GameResultPipe.leaderboardPipeAll(_filteredRaw);
    });
  }


  void _sortData(int columnIndex, bool ascending) {
    if (_sortCriteriaCounter == 0) {
      _presentationData = GameResultPipe.leaderboardPipeAll(_filteredRaw);
    } else {
      ascending = (_sortCriteriaCounter % 2 == 0);
      _presentationData.sort((a, b) {
        int compare;
        var valueA = a.values.elementAt(columnIndex);
        var valueB = b.values.elementAt(columnIndex);

        // oooo boze
        if (columnIndex == 3) {
          double doubleA = double.tryParse(valueA as String) ?? 0;
          double doubleB = double.tryParse(valueB as String) ?? 0;
          compare = doubleA.compareTo(doubleB);
        } else {
          compare = valueA.toString().compareTo(valueB.toString());
        }

        return ascending ? compare : -compare;
      });
    }

    _sortColumnIndex = columnIndex;
    _sortAscending = ascending;
  }


  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: DropdownMenu<String>(
                      // leadingIcon: const Icon(Icons.gamepad_outlined, size: 16),
                      hintText: localization.gameNameFilterHintText,
                      textStyle: const TextStyle(fontSize: 14.0),
                      initialSelection: '',
                      onSelected: (gameName) {
                        _selectedGameName = gameName ?? '';
                        _applyFilters();
                      },
                      dropdownMenuEntries: [
                        DropdownMenuEntry(
                          value: 'wordle',
                          label: localization.wordleGameTitle,
                        ),
                        DropdownMenuEntry(
                          value: 'tic-tac-toe',
                          label: localization.ticTacToeGameTitle,
                        ),
                        DropdownMenuEntry(
                          value: 'nerdle',
                          label: localization.mathQuizGameTitle,
                        ),
                        DropdownMenuEntry(
                          value: '',
                          label: localization.allGames,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextField(
                      controller: _usernameFilterController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: localization.usernameFilterHintText,
                      ),
                      onChanged: (_) => _applyFilters(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (_presentationData.isNotEmpty)
              DataTable(
                columns: [
                  DataColumn(
                    onSort: (index, ascending) {
                      setState(() {
                        _sortCriteriaCounter = (_sortCriteriaCounter + 1) % 3;
                        _sortData(index + 1, ascending);
                      });
                    },
                    label: Expanded(
                      child: Text(
                        localization.usernameHeaderColumnText,
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    onSort: (index, ascending) {
                      setState(() {
                        _sortCriteriaCounter = (_sortCriteriaCounter + 1) % 3;
                        _sortData(index + 1, ascending);
                      });
                    },
                    label: Expanded(
                      child: Text(
                        localization.gameNameHeaderColumnText,
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    onSort: (index, ascending) {
                      setState(() {
                        _sortCriteriaCounter = (_sortCriteriaCounter + 1) % 3;
                        _sortData(index + 1, ascending);
                      });
                    },
                    label: Expanded(
                      child: Text(
                        localization.scoreHeaderColumnText,
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ],
                rows: _presentationData.map((entry) {
                  return DataRow(
                    cells: [
                      DataCell(Text(entry['username']! as String)),
                      DataCell(Text(entry['gameName']! as String)),
                      DataCell(Text(entry['score']! as String)),
                    ],
                  );
                }).toList(),
              )
            else
              Center(child: Text(localization.noDataToDisplay)),
          ],
        ),
      ),
    );
  }
}