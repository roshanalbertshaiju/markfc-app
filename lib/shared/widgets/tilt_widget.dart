import 'package:flutter/material.dart';

class TiltWidget extends StatefulWidget {
  final Widget child;
  final double maxTilt;

  const TiltWidget({
    super.key,
    required this.child,
    this.maxTilt = 0.1,
  });

  @override
  State<TiltWidget> createState() => _TiltWidgetState();
}

class _TiltWidgetState extends State<TiltWidget> {
  double _x = 0;
  double _y = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        final size = MediaQuery.of(context).size;
        setState(() {
          _x += (details.delta.dx / size.width) * 2;
          _y -= (details.delta.dy / size.height) * 2;
          
          _x = _x.clamp(-widget.maxTilt, widget.maxTilt);
          _y = _y.clamp(-widget.maxTilt, widget.maxTilt);
        });
      },
      onPanEnd: (_) {
        setState(() {
          _x = 0;
          _y = 0;
        });
      },
      child: AnimatedRotation(
        duration: const Duration(milliseconds: 200),
        turns: 0, // Not using turns but transform for deeper control
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transformAlignment: FractionalOffset.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // perspective
            ..rotateX(_y)
            ..rotateY(_x),
          child: widget.child,
        ),
      ),
    );
  }
}
