import 'package:flutter/widgets.dart';
import 'package:grid_board/src/grid_cell_controller.dart';

import 'grid_cell_status.dart';

typedef GridCellBuilder = Widget Function(GridCellStatus status);

/// GridCell has multiple child widgets which defined with [gridCellChildMap]
/// When the [GridCellStatus] changed, a transition effect applied to switch between childs.
class GridCell extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          Widget currentChild =
              gridCellChildMap[controller.status] ?? Container();
          return AnimatedSwitcher(
            duration: animationDuration,
            child: currentChild,
          );
        });
  }
}
/*
class GridCell extends {
  Widget _child = Container();
  Widget get child => _child;
  GridCellBuilder builder;
  GridCell({
    required this.builder,
  });

  void updateStatus(GridCellStatus status) {
    Widget newChild = builder(status);

  }
}

class LetterBox extends GridCell {
  LetterBox({required super.index, super.stringValue}) {
    child = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0x66AABBCC),
          border: Border.all(
            color: Color(0xFF111111),
            width: 3,
          ),
        ),
        child: FittedBox(child: Text(stringValue)));
  }
}
*/
