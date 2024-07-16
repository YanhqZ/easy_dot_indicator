import 'package:flutter/material.dart';

import '../dot.dart';

/// EasyDotIndicatorCustomConfig extension
extension EasyDotIndicatorCustomConfigExt on EasyDotIndicatorCustomConfig {
  /// Get the style of the dot
  DotStyle style(Dot dot) {
    return switch (dot) {
      Dot.big => big,
      Dot.middle => middle,
      Dot.small => small,
    };
  }

  /// Get the size of the custom dot during animation progress
  Size getSize({
    required Dot cur,
    required Dot pre,
    required double progress,
  }) {
    return Size.lerp(
      style(pre).size,
      style(cur).size,
      progress.clamp(0, 1),
    )!;
  }

  /// Get the color of the custom dot during animation progress
  Color getColor({
    required Dot cur,
    required Dot pre,
    required double progress,
  }) {
    if (activeColor != null && inactiveColor != null) {
      final bool? pendingActive;
      if (cur == Dot.big && pre != cur) {
        // inactive -> active
        pendingActive = true;
      } else if (pre == Dot.big && cur != pre) {
        // active -> inactive
        pendingActive = false;
      } else {
        // no change between active and inactive
        pendingActive = null;
      }
      return pendingActive == null
          ? cur == Dot.big
              ? activeColor!
              : inactiveColor!
          : pendingActive == true
              ? Color.lerp(
                  inactiveColor,
                  activeColor,
                  progress.clamp(0, 1),
                )!
              : Color.lerp(
                  activeColor,
                  inactiveColor,
                  progress.clamp(0, 1),
                )!;
    } else {
      return Color.lerp(
        style(pre).color,
        style(cur).color,
        progress.clamp(0, 1),
      )!;
    }
  }
}
