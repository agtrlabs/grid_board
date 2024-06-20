import 'package:flutter/widgets.dart';
import 'package:grid_board/src/grid_cell_animation_pumpers.dart';
import 'package:grid_board/src/grid_cell_controller.dart';
import 'package:grid_board/src/grid_cell_status.dart';
import 'package:grid_board/src/helpers/cell_animation_handler.dart';

typedef GridCellBuilder = Widget Function(GridCellStatus status);

/// GridCell has multiple child widgets which defined with [gridCellChildMap]
/// When the [GridCellStatus] changed, a transition effect applied to
/// switch between children.
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
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        var currentChild =
            widget.gridCellChildMap[widget.controller.status] ?? Container();
        currentChild = CellAnimationHandler.animateCell(
          child: currentChild,
          controller: widget.controller,
          pumpers: pumpers,
        );
        return AnimatedBuilder(
          animation: widget.controller.animationController,
          builder: (context, _) {
            return AnimatedSwitcher(
              duration: widget.animationDuration,
              child: currentChild,
            );
          },
        );
      },
    );
  }
}
