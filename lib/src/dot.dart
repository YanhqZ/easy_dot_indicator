import 'package:flutter/material.dart';

/// Dot style
enum Dot { big, middle, small }

extension DotExt on Dot {
  double get opacity => _dotOpacities[this]!;

  Size get size => _dotSize[this]!;
}

const _dotOpacities = {
  Dot.big: 1.0,
  Dot.middle: 0.8,
  Dot.small: 0.6,
};

final _dotSize = {
  Dot.big: const Size(8, 8),
  Dot.middle: const Size(6, 6),
  Dot.small: const Size(4, 4),
};

class IndicatorDotPainter extends CustomPainter {
  late final double _opacity;

  IndicatorDotPainter(double opacity) {
    _opacity = opacity;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2,
        Paint()..color = Colors.white.withOpacity(_opacity));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
