class GameResult {
  final int? id;
  final String username;
  final double score;
  final String gameName;
  final DateTime dateTime;

  const GameResult({
    required this.id,
    required this.username,
    required this.gameName,
    required this.score,
    required this.dateTime,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'username': username,
      'score': score,
      'dateTime': dateTime.toString(),
      'gameName': gameName
    };
  }

  static GameResult fromMap(Map<String, Object?> data) {
    return GameResult(
      id: data['id'] as int,
      username: data['username'] as String,
      gameName: data['gameName'] as String,
      score: (data['score'] as num).toDouble(),
      dateTime: DateTime.parse(data['dateTime'] as String),
    );
  }

  @override
  String toString() {
    return 'GameResult{$id, $username, $gameName, $score, $dateTime}';
  }
}
