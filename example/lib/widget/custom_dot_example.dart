import 'package:easy_dot_indicator/easy_dot_indicator.dart';
import 'package:flutter/material.dart';

class CustomDotExample extends StatefulWidget {
  const CustomDotExample({super.key});

  @override
  State<CustomDotExample> createState() => _CustomDotExampleState();
}

class _CustomDotExampleState extends State<CustomDotExample> {
  EasyDotIndicatorController indicatorController = EasyDotIndicatorController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned.fill(
            child: PageView.builder(
              itemBuilder: (_, index) => Container(
                alignment: Alignment.center,
                color: Colors.red,
                child: Text(
                  'CustomDot:Item$index',
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              itemCount: 10,
              onPageChanged: (index) {
                indicatorController.updateIndex(index);
              },
            ),
          ),
          Positioned(
            bottom: 10,
            child: EasyDotIndicator(
              visibleNum: 5,
              count: 10,
              controller: indicatorController,
              dotConfig: EasyDotIndicatorCustomConfig(
                big: _getDotStyle(Dot.big),
                middle: _getDotStyle(Dot.middle),
                small: _getDotStyle(Dot.small),
                animDuration: const Duration(milliseconds: 200),
                gap: 6,
                customDotBuilder: (anim, cur, pre) {
                  final preSize = _getDotStyle(pre).size;
                  final curSize = _getDotStyle(cur).size;
                  return CustomPaint(
                    painter: IndicatorCustomDotPainter(),
                    size: Size.lerp(preSize, curSize, anim.value)!,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  DotStyle _getDotStyle(Dot dot) {
    return switch (dot) {
      Dot.big => const DotStyle(size: Size.square(12)),
      Dot.middle => const DotStyle(size: Size.square(9)),
      Dot.small => const DotStyle(size: Size.square(6)),
    };
  }
}

class IndicatorCustomDotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(size.width / 2, (size.height - size.width) / 2); // Top point
    path.lineTo(size.width, size.height / 2); // Right point
    path.lineTo(size.width / 2, (size.height + size.width) / 2); // Bottom point
    path.lineTo(0, size.height / 2); // Left point
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
