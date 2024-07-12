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
  final EasyDotIndicatorController controller;

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

class _EasyDotIndicatorState extends State<EasyDotIndicator>
    with SingleTickerProviderStateMixin {
  late ScrollController scrollController;
  late List<Dot> dots;
  late Animation<double> animation;
  late AnimationController animController;
  final ValueNotifier<double> widthNotifier = ValueNotifier<double>(0);
  int current = 0;
  int pending = 0;

  /// The number of dots that can be displayed to the left or right of the current dot
  late int leftDotNum;
  late int rightDotNum;

  EasyDotIndicatorController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    if (!widget.visibleNum.isEven) {
      leftDotNum = rightDotNum = (widget.visibleNum - 1) ~/ 2;
    } else {
      leftDotNum = widget.visibleNum ~/ 2;
      rightDotNum = widget.visibleNum ~/ 2 - 1;
    }
    dots = List.generate(
        widget.count, (index) => indicatorDot(index, controller.current));
    animController = AnimationController(
        duration: const Duration(milliseconds: 150), vsync: this);
    animation = Tween<double>(begin: 0, end: 1).animate(animController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // when the animation is completed, adjust the width and scroll offset.
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            // widthNotifier.value = _calculateIndicatorWidth(current);
            scrollController.jumpTo(_calculateScrollOffset(current));
          });
        }
      });
  }

  @override
  void dispose() {
    super.dispose();
    animController.dispose();
  }

  /// Update the current dot index
  void updateIndex(int index) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      pending = index;
      if (current != pending) {
        if (animController.isAnimating) {
          animController.stop(canceled: true);
        }
        // Calculate the bigger width between the current and pending and update UI
        // to promise the dot can be displayed completely during the animation
        widthNotifier.value = max(
          _calculateIndicatorWidth(pending),
          _calculateIndicatorWidth(current),
        );
        // Start animation
        animController.reset();
        animController.forward();
        // Update the scroll offset
        scrollController.animateTo(
          _calculateScrollOffset(index),
          duration: const Duration(milliseconds: 150),
          curve: Curves.linear,
        );
        current = index;
      }
    });
  }

  /// Calculate indicator width according to the [count] of dots
  double _calculateIndicatorWidth(int index) {
    final count = widget.count;
    final visibleNum = widget.visibleNum;
    final gap = widget.gap;
    if (count < 1) {
      return 0;
    } else if (count < 3) {
      return Dot.big.size.width +
          Dot.middle.size.width * (visibleNum - 1) +
          (visibleNum - 1) * gap;
    } else {
      if (index == count - 1 || index == 0) {
        return Dot.big.size.width +
            Dot.middle.size.width * 1 +
            Dot.small.size.width * (visibleNum - 1 - 1) +
            (visibleNum - 1) * gap;
      } else {
        return Dot.big.size.width +
            Dot.middle.size.width * 2 +
            Dot.small.size.width * (visibleNum - 1 - 2) +
            (visibleNum - 1) * gap;
      }
    }
  }

  /// Calculate indicator scroll offset
  double _calculateScrollOffset(int index) {
    // Calculate the number of invisible dots to the left of the indicator
    int leftInvisibleDotNum = 0;
    if (index <= leftDotNum) {
      leftInvisibleDotNum = 0;
    } else if (index <= widget.count - widget.visibleNum + leftDotNum) {
      leftInvisibleDotNum = index - leftDotNum;
    } else if (index < widget.count - 1) {
      leftInvisibleDotNum = widget.count - widget.visibleNum;
    } else {
      return scrollController.position.maxScrollExtent;
    }
    final gap = widget.gap;
    List<Dot> dots =
        List.generate(leftInvisibleDotNum, (i) => indicatorDot(i, index));
    return dots.fold(0.0,
            (previousValue, element) => previousValue + element.size.width) +
        dots.length * gap;
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      controller._context = context;
      // Update the width of the indicator when the context injected
      widthNotifier.value = _calculateIndicatorWidth(pending);
      return ValueListenableBuilder(
        valueListenable: widthNotifier,
        builder: (context, width, child) {
          return SizedBox(
            width: width,
            height: Dot.big.size.height,
            child: child,
          );
        },
        child: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: IgnorePointer(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              controller: scrollController,
              children: List<Widget>.from(List.generate(widget.count, (index) {
                return AnimatedBuilder(
                  animation: animation,
                  builder: (BuildContext context, child) {
                    final curDot = indicatorDot(index, current);
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
                          animation.value *
                              (curDot.size.width - preDot.size.width);
                    }
                    if (animation.value >= 1) {
                      dots[index] = curDot;
                    }
                    return CustomPaint(
                      painter: IndicatorDotPainter(opacity),
                      size: Size(sizeWidth, sizeWidth),
                    );
                  },
                );
              })
                  .toList()
                  .expand((e) => [e, SizedBox(width: widget.gap)])
                  .toList()
                ..removeLast()),
            ),
          ),
        ),
      );
    });
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

/// Controller for controlling the status of the dot indicator
class EasyDotIndicatorController {
  BuildContext? _context;

  int get current => _accessDotIndicatorWidgetState?.current ?? 0;

  _EasyDotIndicatorState? get _accessDotIndicatorWidgetState =>
      _context?.mounted == true
          ? _context?.findAncestorStateOfType<_EasyDotIndicatorState>()
          : null;

  void updateIndex(int index) {
    final state = _accessDotIndicatorWidgetState;
    if (state == null) return;
    state.updateIndex(index);
  }
}
