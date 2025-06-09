import 'package:flutter/material.dart';
import 'package:mozgalica/resources/configurations/variables.dart';

class GameComponent extends StatefulWidget {
  const GameComponent({super.key, required this.widgetComponent});

  final Widget widgetComponent;

  @override
  State<GameComponent> createState() => _GameComponentState();
}

class _GameComponentState extends State<GameComponent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.key,
      body: widget.widgetComponent,
      appBar: AppBar(
        title: Text(appTitle),
      ),
    );
  }
}
