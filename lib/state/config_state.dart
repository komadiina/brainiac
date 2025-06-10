import 'package:flutter/material.dart';
import 'package:mozgalica/resources/configurations/variables.dart';

class ConfigurationsState extends ChangeNotifier {
  Duration _animationDuration = durationNormal;
  final double _beginScale = 0.85;
  final double _endScale = 1.0;

  Duration get animationDuration =>
      Duration(milliseconds: _animationDuration.inMilliseconds);

  double get beginScale => _beginScale;
  double get endScale => _endScale;

  void updateDuration(Duration newDuration) {
    _animationDuration = newDuration;
    notifyListeners();
  }
}
