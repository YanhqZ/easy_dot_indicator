import 'package:easy_dot_indicator/easy_dot_indicator.dart';
import 'package:easy_dot_indicator/src/extension/list_ext.dart';
import 'package:flutter/material.dart';

/// Dot indicator
class EasyDotIndicator extends StatefulWidget {
  /// The maximum number of dots that can be displayed
  final int visibleNum;

  /// The actual total number of dots in the indicator
  final int count;

  /// Controller, providing external modification status
  final EasyDotIndicatorController controller;

  /// Custom configuration
  final EasyDotIndicatorCustomConfig dotConfig;

  const EasyDotIndicator({
    required this.visibleNum,
    required this.count,
    required this.controller,
    this.dotConfig = const EasyDotIndicatorCustomConfig(),
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
  late double maxWidth;
  int current = 0;
  int pending = 0;

  EasyDotIndicatorController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    dots = List.generate(
        widget.count, (index) => indicatorDot(index, controller.current));
    // Calculate the max width to promise the dot can be displayed completely during the animation
    maxWidth = _calculateIndicatorMaxWidth();
    animController = AnimationController(
        duration: widget.dotConfig.animDuration, vsync: this);
    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: animController,
      curve: widget.dotConfig.animCurve,
    ))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // when the animation is completed, adjust the scroll offset.
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
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
        // Start animation
        animController.reset();
        animController.forward();
        // Update the scroll offset
        scrollController.animateTo(
          _calculateScrollOffset(index),
          duration: widget.dotConfig.animDuration,
          curve: widget.dotConfig.animCurve,
        );
        current = index;
      }
    });
  }

  /// Calculate indicator max width
  double _calculateIndicatorMaxWidth() {
    final count = widget.count;
    final visibleNum = widget.visibleNum;
    final gap = widget.dotConfig.gap;
    if (count < 1) {
      return 0;
    } else if (count < 3) {
      return widget.dotConfig.big.size.width +
          widget.dotConfig.middle.size.width * (visibleNum - 1) +
          (visibleNum - 1) * gap;
    } else {
      return widget.dotConfig.big.size.width +
          widget.dotConfig.middle.size.width * 2 +
          widget.dotConfig.small.size.width * (visibleNum - 1 - 2) +
          (visibleNum - 1) * gap;
    }
  }

  /// Calculate indicator scroll offset
  double _calculateScrollOffset(int index) {
    // Calculate the number of invisible dots to the left of the indicator
    int leftInvisibleDotNum = 0;
    // The number of dots to the left of the middle visible dot
    final leftDotNum = widget.visibleNum.isEven
        ? widget.visibleNum ~/ 2
        : (widget.visibleNum - 1) ~/ 2;
    if (index <= leftDotNum) {
      leftInvisibleDotNum = 0;
    } else if (index <= widget.count - widget.visibleNum + leftDotNum) {
      leftInvisibleDotNum = index - leftDotNum;
    } else if (index < widget.count - 1) {
      leftInvisibleDotNum = widget.count - widget.visibleNum;
    } else {
      return scrollController.position.maxScrollExtent;
    }
    final gap = widget.dotConfig.gap;
    List<Dot> dots =
        List.generate(leftInvisibleDotNum, (i) => indicatorDot(i, index));
    return dots.fold(
            0.0, (pre, e) => pre + widget.dotConfig.style(e).size.width) +
        dots.length * gap;
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      controller._context = context;
      return Container(
        alignment: Alignment.center,
        width: maxWidth,
        height: widget.dotConfig.big.size.height,
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
                  builder: (BuildContext context, _) {
                    final preDot = dots[index];
                    final curDot = indicatorDot(index, current);
                    if (animation.value >= 1) {
                      dots[index] = curDot;
                    }
                    if (widget.dotConfig.customDotBuilder != null) {
                      // Custom dot widget
                      return widget.dotConfig.customDotBuilder!(
                        animation,
                        indicatorDot(index, current),
                        preDot,
                      );
                    }
                    final Size size = widget.dotConfig.getSize(
                      cur: curDot,
                      pre: preDot,
                      progress: animation.value,
                    );
                    Color color = widget.dotConfig.getColor(
                      cur: curDot,
                      pre: preDot,
                      progress: animation.value,
                    );
                    return CustomPaint(
                      painter: IndicatorDotPainter(color),
                      size: size,
                    );
                  },
                );
              })).gap(SizedBox(width: widget.dotConfig.gap)),
            ),
          ),
        ),
      );
    });
  }

  @override
  void didUpdateWidget(covariant EasyDotIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    maxWidth = _calculateIndicatorMaxWidth();
    scrollController.jumpTo(
      _calculateScrollOffset(current),
    );
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

  /// Update the current dot index
  void updateIndex(int index) {
    final state = _accessDotIndicatorWidgetState;
    if (state == null) return;
    state.updateIndex(index);
  }
}
