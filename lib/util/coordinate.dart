class Coordinate {
  const Coordinate({required this.x, required this.y});

  final int x;
  final int y;

  @override
  String toString() {
    return 'Coordinate(x=$x, y=$y})';
  }
}
