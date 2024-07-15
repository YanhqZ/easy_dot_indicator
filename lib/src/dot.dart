import 'package:flutter/material.dart';

/// Dot style
enum Dot { big, middle, small }

/// Dot style configuration
class DotStyle {
  final double opacity;
  final Size size;
  final Color color;

  const DotStyle({
    this.opacity = 1,
    required this.size,
    this.color = Colors.white,
  });
}

/// Custom dot builder func
/// [anim] Animation controller for dot transition
/// [cur] Current dot
/// [pre] Previous dot
typedef CustomDotBuilder = Widget Function(
  Animation<double> anim,
  Dot cur,
  Dot pre,
);

/// Custom configuration for dot indicator
class EasyDotIndicatorCustomConfig {
  /// Big dot style
  final DotStyle big;

  /// Middle dot style
  final DotStyle middle;

  /// Small dot style
  final DotStyle small;

  /// Gap between dots
  final double gap;

  /// Animation duration
  final Duration animDuration;

  /// Animation curve
  final Curve animCurve;

  /// Custom dot builder
  final CustomDotBuilder? customDotBuilder;

  const EasyDotIndicatorCustomConfig({
    this.big = const DotStyle(
      opacity: 1.0,
      size: Size.square(8),
      color: Colors.white,
    ),
    this.middle = const DotStyle(
      opacity: 0.8,
      size: Size.square(6),
      color: Colors.white,
    ),
    this.small = const DotStyle(
      opacity: 0.6,
      size: Size.square(4),
      color: Colors.white,
    ),
    this.gap = 6,
    this.animDuration = const Duration(milliseconds: 150),
    this.animCurve = Curves.linear,
    this.customDotBuilder,
  });

  DotStyle style(Dot dot) {
    return switch (dot) {
      Dot.big => big,
      Dot.middle => middle,
      Dot.small => small,
    };
  }
}

/// Default painter for drawing indicator dot
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
