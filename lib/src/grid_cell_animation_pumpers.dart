import 'package:flutter/material.dart';
import 'package:grid_board/grid_board.dart';

class GridCellAnimationPumpers {
  GridCellAnimationPumpers(this.controller);

  final GridCellController controller;

  Widget applyPulseAnimation(Widget child, PulseAnimation pulse) {
    controller.animationController.duration = pulse.duration;

    return Stack(
      children: [
        FadeTransition(
          opacity: Tween<double>(begin: 1, end: pulse.pulseOpacity).animate(
            CurvedAnimation(
              parent: controller.animationController,
              curve: pulse.curve,
            ),
          ),
          child: ScaleTransition(
            scale: Tween<double>(begin: 1, end: pulse.pulseSize).animate(
              CurvedAnimation(
                parent: controller.animationController,
                curve: pulse.curve,
              ),
            ),
            // we could just use a colorFilter and modulate it
            // child: ColorFiltered(
            //     colorFilter: ColorFilter.mode(
            //     pulse.pulseColor,
            //     BlendMode.modulate,
            //   ),
            child: Container(
              constraints: const BoxConstraints.expand(),
              decoration: BoxDecoration(
                color: pulse.pulseColor,
                borderRadius: const BorderRadius.all(Radius.circular(2)),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
