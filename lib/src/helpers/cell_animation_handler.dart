import 'package:flutter/material.dart';
import 'package:grid_board/src/grid_cell_animation_pumpers.dart';
import 'package:grid_board/src/grid_cell_controller.dart';
import 'package:grid_board/src/value_objects/animation_style.dart';

abstract class CellAnimationHandler {
  static Widget animateCell({
    required Widget child,
    required GridCellController controller,
    required GridCellAnimationPumpers pumpers,
  }) {
    var currentChild = child;
    switch (controller.animationStyle) {
      case PulseAnimation(
          duration: final duration,
          pulseInterval: final pulseInterval,
          pulseOpacity: final pulseOpacity,
          pulseColor: final pulseColor,
          pulseSize: final pulseSize,
          curve: final curve,
        ):
        currentChild = pumpers.applyPulseAnimation(
          currentChild,
          PulseAnimation(
            duration: duration,
            pulseInterval: pulseInterval,
            pulseOpacity: pulseOpacity,
            pulseColor: pulseColor,
            pulseSize: pulseSize,
            curve: curve,
          ),
        );
      case null:
        break;
      case RotateAnimation():
      // TODO: Handle this case.
      case ScaleAnimation():
      // TODO: Handle this case.
      case SlideAnimation():
      // TODO: Handle this case.
      case SpinAnimation():
      // TODO: Handle this case.
      case ZoomAnimation():
      // TODO: Handle this case.
      case CustomAnimation():
      // TODO: Handle this case.
    }

    return currentChild;
  }
}
