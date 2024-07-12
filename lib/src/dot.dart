import 'package:flutter/material.dart';

/// Dot style
enum Dot { big, middle, small }

class DotStyle {
  final double opacity;
  final double size;
  final Color color;

  const DotStyle({
    required this.opacity,
    required this.size,
    required this.color,
  });
}

class EasyDotIndicatorDotConfig {
  final DotStyle big;
  final DotStyle middle;
  final DotStyle small;

  const EasyDotIndicatorDotConfig({
    this.big = const DotStyle(opacity: 1.0, size: 8, color: Colors.white),
    this.middle = const DotStyle(opacity: 0.8, size: 6, color: Colors.white),
    this.small = const DotStyle(opacity: 0.6, size: 4, color: Colors.white),
  });

  DotStyle style(Dot dot) {
    return switch (dot) {
      Dot.big => big,
      Dot.middle => middle,
      Dot.small => small,
    };
  }
}

class IndicatorDotPainter extends CustomPainter {
  final Color _color;

  IndicatorDotPainter(Color color) : _color = color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      Paint()..color = _color,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
