import 'package:flutter/widgets.dart';
import 'package:grid_board/src/grid_cell_animation_pumpers.dart';
import 'package:grid_board/src/grid_cell_controller.dart';
import 'package:grid_board/src/value_objects/animation_style.dart';

import 'grid_cell_status.dart';

typedef GridCellBuilder = Widget Function(GridCellStatus status);

/// GridCell has multiple child widgets which defined with [gridCellChildMap]
/// When the [GridCellStatus] changed, a transition effect applied to switch between childs.
class GridCell extends StatefulWidget {
  const GridCell({
    required this.gridCellChildMap,
    required this.controller,
    super.key,
    this.animationDuration = const Duration(milliseconds: 500),
  });

  final Duration animationDuration;
  final Map<GridCellStatus, Widget> gridCellChildMap;
  final GridCellController controller;

  @override
  State<GridCell> createState() => _GridCellState();
}

class _GridCellState extends State<GridCell> with TickerProviderStateMixin {
  late GridCellAnimationPumpers pumpers;

  @override
  void initState() {
    super.initState();
    widget.controller.initAnimationController(this);
    pumpers = GridCellAnimationPumpers(widget.controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: widget.controller.animationController,
        builder: (context, _) {
          Widget currentChild =
              widget.gridCellChildMap[widget.controller.status] ?? Container();
          switch (widget.controller.animationStyle) {
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
          return ListenableBuilder(
              listenable: widget.controller,
              builder: (context, _) {
                return AnimatedSwitcher(
                  duration: widget.animationDuration,
                  child: currentChild,
                );
              });
        });
  }
}
