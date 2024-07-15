# easy_dot_indicator

A simple dot-style indicator Flutter widget.

![image](https://raw.githubusercontent.com/YanhqZ/img/master/blob/easy_dot_indicator/img1.gif)

![image](https://raw.githubusercontent.com/YanhqZ/img/master/blob/easy_dot_indicator/img2.gif)

## Getting Started

Combine with PageView:

```dart
class _PageViewExampleState extends State<PageViewExample> {
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
              // itemBuilder: (_, index) => ...,
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
            ),
          ),
        ],
      ),
    );
  }
}
```

Combine with CarouselSlider:
```dart
class _CarouselSliderExampleState extends State<CarouselSliderExample> {
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
            child: CarouselSlider(
              items: List.generate(
                10,
                (index) => Container(
                  alignment: Alignment.center,
                  color: Colors.grey,
                  child: Text(
                    'CarouselSlider:Item$index',
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
              options: CarouselOptions(
                viewportFraction: 1,
                onPageChanged: (index, _) {
                  indicatorController.updateIndex(index);
                },
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            child: EasyDotIndicator(
                visibleNum: 5,
                count: 10,
                controller: indicatorController,
                ),
          ),
        ],
      ),
    );
  }
}
```

You can custom dot widget like this:
```dart

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
          //...
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
                  final size = Size(
                    preSize.width +
                        anim.value * (curSize.width - preSize.width),
                    preSize.height +
                        anim.value * (curSize.height - preSize.height),
                  );
                  return CustomPaint(
                    painter: IndicatorCustomDotPainter(),
                    size: size,
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
```


For help getting started with Flutter development, view the online
[documentation](https://flutter.dev/).

For instructions integrating Flutter modules to your existing applications,
see the [add-to-app documentation](https://flutter.dev/docs/development/add-to-app).
