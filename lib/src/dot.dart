import 'package:flutter/material.dart';

/// Dot style
enum Dot { big, middle, small }

/// Dot style configuration
class DotStyle {
  final Size size;
  final Color color;

  const DotStyle({
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

  /// inactive color, will override the color in [DotStyle]
  final Color? inactiveColor;

  /// active color, will override the color in [DotStyle]
  final Color? activeColor;

  const EasyDotIndicatorCustomConfig({
    this.big = const DotStyle(
      size: Size.square(8),
      color: Color(0xFFFFFFFF),
    ),
    this.middle = const DotStyle(
      size: Size.square(6),
      color: Color(0xCCFFFFFF),
    ),
    this.small = const DotStyle(
      size: Size.square(4),
      color: Color(0x99FFFFFF),
    ),
    this.gap = 6,
    this.animDuration = const Duration(milliseconds: 150),
    this.animCurve = Curves.linear,
    this.customDotBuilder,
    this.inactiveColor,
    this.activeColor,
  }) : assert(!(inactiveColor != null) ^ (activeColor != null));
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
