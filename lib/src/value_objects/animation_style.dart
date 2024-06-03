import 'package:flutter/animation.dart';

sealed class CellAnimationStyle {
  // we can collect the common properties here

  /// The duration of the animation.
  Duration get duration;

  /// The curve of the animation.
  Curve get curve;
}

final class PulseAnimation implements CellAnimationStyle {
  /// Creates a pulse animation style.
  PulseAnimation({
    this.duration = const Duration(milliseconds: 1000),
    this.pulseInterval = const Duration(milliseconds: 500),
    this.pulseOpacity = 0.5,
    this.pulseColor,
    this.pulseSize = 1.0,
    this.curve = Curves.easeInOut,
  });

  @override
  final Duration duration;

  /// The interval between pulses.
  final Duration pulseInterval;

  /// The opacity of the pulse effect.
  final double pulseOpacity;

  /// The color of the pulse effect.
  final Color? pulseColor;

  /// The size of the pulse effect.
  final double pulseSize;

  @override
  final Curve curve;
}

final class RotateAnimation implements CellAnimationStyle {
  /// Creates a rotate animation style.
  RotateAnimation({
    this.duration = const Duration(milliseconds: 1000),
    this.rotateAngle = 0.5,
    this.curve = Curves.easeInOut,
  });

  @override
  final Duration duration;

  /// The angle of the rotate effect.
  final double rotateAngle;

  @override
  final Curve curve;
}

final class ScaleAnimation implements CellAnimationStyle {
  /// Creates a scale animation style.
  ScaleAnimation({
    this.duration = const Duration(milliseconds: 1000),
    this.scaleSize = 0.5,
    this.curve = Curves.easeInOut,
  });

  @override
  final Duration duration;

  /// The size of the scale effect.
  final double scaleSize;

  @override
  final Curve curve;
}

final class SlideAnimation implements CellAnimationStyle {
  /// Creates a slide animation style.
  SlideAnimation({
    this.duration = const Duration(milliseconds: 1000),
    this.slideOffset = 0.5,
    this.curve = Curves.easeInOut,
  });

  @override
  final Duration duration;

  /// The offset of the slide effect.
  final double slideOffset;

  @override
  final Curve curve;
}

final class SpinAnimation implements CellAnimationStyle {
  /// Creates a spin animation style.
  SpinAnimation({
    this.duration = const Duration(milliseconds: 1000),
    this.spinAngle = 0.5,
    this.curve = Curves.easeInOut,
  });

  @override
  final Duration duration;

  /// The angle of the spin effect.
  final double spinAngle;

  @override
  final Curve curve;
}

final class ZoomAnimation implements CellAnimationStyle {
  /// Creates a zoom animation style.
  ZoomAnimation({
    this.duration = const Duration(milliseconds: 1000),
    this.zoomSize = 0.5,
    this.curve = Curves.easeInOut,
  });

  @override
  final Duration duration;

  /// The size of the zoom effect.
  final double zoomSize;

  @override
  final Curve curve;
}

final class CustomAnimation implements CellAnimationStyle {
  /// Creates a custom animation style.
  CustomAnimation({
    required this.duration,
    required this.curve,
    required this.customAnimation,
  });

  @override
  final Duration duration;

  /// The custom animation.
  final Animation<double> customAnimation;

  @override
  final Curve curve;
}
