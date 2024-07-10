import 'dart:math';

import 'package:flutter/material.dart';

import 'dot.dart';

/// Dot indicator
class EasyDotIndicator extends StatefulWidget {
  /// The maximum number of dots that can be displayed
  final int visibleNum;

  /// The actual total number of dots in the indicator
  final int count;

  /// Controller, providing external modification status
  final DotIndicatorController controller;

  /// Dot gap
  final double gap;

  const EasyDotIndicator({
    required this.visibleNum,
    required this.count,
    required this.controller,
    this.gap = 6,
    super.key,
  });

  @override
  State<EasyDotIndicator> createState() => _EasyDotIndicatorState();
}

class _EasyDotIndicatorState extends State<EasyDotIndicator> {
  late GlobalObjectKey stateKey;

  @override
  void initState() {
    super.initState();

    /// The state at this level is mainly used to create keys.
    stateKey = (widget.key as GlobalObjectKey?) ??
        GlobalObjectKey("_EasyDotIndicatorState${Random().nextInt(10000)}");
    widget.controller._stateKey = stateKey;
  }

  @override
  Widget build(BuildContext context) {
    int visibleNum = widget.visibleNum;
    if (widget.visibleNum > widget.count) {
      visibleNum = widget.count;
    }
    return DotIndicatorWidget(
      key: stateKey,
      visibleNum: visibleNum,
      maxNum: widget.count,
      controller: widget.controller,
      gap: widget.gap,
    );
  }
}

class DotIndicatorWidget extends StatefulWidget {
  final int visibleNum;
  final int maxNum;
  final double gap;
  final DotIndicatorController controller;

  const DotIndicatorWidget({
    required this.visibleNum,
    required this.maxNum,
    required this.controller,
    required this.gap,
    super.key,
  });

  @override
  State<DotIndicatorWidget> createState() => DotIndicatorWidgetState();
}

class DotIndicatorWidgetState extends State<DotIndicatorWidget>
    with SingleTickerProviderStateMixin {
  late ScrollController scrollController;
  late List<Dot> dots;
  late Animation<double> animation;
  late AnimationController controller;

  /// The number of dots that can be displayed to the left or right of the current dot
  late int sideDotNum;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    sideDotNum = (widget.visibleNum - 1) ~/ 2;
    dots = List.generate(widget.maxNum,
        (index) => indicatorDot(index, widget.controller.current));
    controller = AnimationController(
        duration: const Duration(milliseconds: 150), vsync: this);
    animation = Tween<double>(begin: 0, end: 1).animate(controller)
      ..addListener(() {
        if (!mounted) return;
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: widget.controller._calculateDotsWidth(widget.visibleNum),
        height: Dot.big.size.height,
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          controller: scrollController,
          children: List<Widget>.from(List.generate(widget.maxNum, (index) {
            final curDot = indicatorDot(index, widget.controller.current);
            final preDot = dots[index];
            final double opacity;
            final double sizeWidth;
            if (preDot.opacity == curDot.opacity) {
              // No need to redraw the dots
              opacity = curDot.opacity;
              sizeWidth = curDot.size.width;
            } else {
              // Need to redraw the dots
              opacity = preDot.opacity +
                  animation.value * (curDot.opacity - preDot.opacity);
              sizeWidth = preDot.size.width +
                  animation.value * (curDot.size.width - preDot.size.width);
            }
            if (animation.value >= 1) {
              dots[index] = curDot;
            }
            return CustomPaint(
              painter: IndicatorDotPainter(opacity),
              size: Size(sizeWidth, sizeWidth),
            );
          }).toList().expand((e) => [e, SizedBox(width: widget.gap)]).toList()
            ..removeLast()),
        ));
  }

  /// Draw a dot based on the current position
  Dot indicatorDot(int dotIndex, int selectedIndex) {
    if (dotIndex == selectedIndex) {
      return Dot.big;
    } else if ((dotIndex - selectedIndex).abs() == 1) {
      return Dot.middle;
    } else {
      return Dot.small;
    }
  }
}

class DotIndicatorController {
  late GlobalObjectKey _stateKey;
  int _current = 0;

  int get current => _current;

  DotIndicatorWidgetState? get _requireDotIndicatorWidgetState =>
      _stateKey.currentState as DotIndicatorWidgetState?;

  void updateIndex(int index) {
    // ignore: invalid_use_of_protected_member
    _stateKey.currentState?.setState(() {
      final state = _requireDotIndicatorWidgetState;
      if (state == null) return;
      if (_current != index) {
        if (state.controller.isAnimating) {
          state.controller.stop(canceled: true);
        }
        state.controller.reset();
        state.controller.forward();
        state.scrollController.animateTo(_calculateScrollOffset(index),
            duration: const Duration(milliseconds: 150), curve: Curves.linear);
      }
      _current = index;
    });
  }

  /// Calculate indicator scroll offset
  double _calculateScrollOffset(int index) {
    final state = _requireDotIndicatorWidgetState;
    if (state == null) return 0;
    index = index + 1;
    double gap = state.widget.gap;
    int side = state.sideDotNum;
    if (index <= side + 1) {
      return 0;
    } else {
      // Num of dot to be moved
      int move = index - side - 1;
      // Num of mid dot that needs to be moved
      int moveMiddle = side < 2 ? 1 : 0;
      // Num of  small dot that need to be moved
      int moveSmall = move >= 0 ? move - moveMiddle : 0;
      //The offset that needs to be moved
      double offset = move * gap +
          moveSmall * Dot.small.size.width +
          moveMiddle * Dot.middle.size.width;
      if (index >= state.widget.maxNum - side) {
        // Avoid overScroll exception
        offset = min(
            offset,
            _calculateDotsWidth(state.widget.maxNum) -
                _calculateDotsWidth(state.widget.visibleNum));
      }
      return offset;
    }
  }

  /// Calculate indicator width according to the [count] of dots
  double _calculateDotsWidth(int count) {
    final state = _requireDotIndicatorWidgetState;
    if (state == null) return 0;
    double gap = state.widget.gap;
    count = max(count, 0);
    if (count < 1) {
      return 0;
    } else if (count < 3) {
      return Dot.big.size.width +
          Dot.middle.size.width * (count - 1) +
          (count - 1) * gap;
    } else {
      return Dot.big.size.width +
          Dot.middle.size.width * 2 +
          Dot.small.size.width * (count - 1 - 2) +
          (count - 1) * gap;
    }
  }
}
