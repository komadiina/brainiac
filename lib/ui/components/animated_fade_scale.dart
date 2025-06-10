import 'package:flutter/material.dart';
import 'package:mozgalica/state/config_state.dart';
import 'package:provider/provider.dart';

class AnimatedFadeScale extends StatefulWidget {
  const AnimatedFadeScale({
    super.key,
    required this.child,
    required this.delay,
    required this.duration,
    this.curve = Curves.easeIn,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final Curve curve;

  @override
  State<AnimatedFadeScale> createState() => _AnimatedFadeScaleState();
}

class _AnimatedFadeScaleState extends State<AnimatedFadeScale> {
  bool widgetLoaded = false;

  Future<void> animate() async {
    final Future<void> animateHelper = Future.delayed(widget.delay, () async {
      if (widgetLoaded == false) {
        setState(() {
          widgetLoaded = true;
        });
      }
    });

    Future.wait([animateHelper]);
  }

  @override
  Widget build(BuildContext context) {
    animate();

    return AnimatedOpacity(
      opacity: widgetLoaded ? 1.0 : 0.0,
      duration: widget.duration,
      curve: widget.curve,
      child: AnimatedScale(
        scale: widgetLoaded
            ? 1.0
            : Provider.of<ConfigurationsState>(context, listen: false).endScale,
        duration: widget.duration,
        curve: widget.curve,
        child: widget.child,
      ),
    );
  }
}
