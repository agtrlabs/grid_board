import 'package:flutter/widgets.dart';
import 'grid_cell_status.dart';

typedef GridCellBuilder = Widget Function(GridCellStatus status);

/// GridCell has multiple child widgets which defined with [gridCellChildMap]
/// When the [GridCellStatus] changed, a transition effect applied to switch between childs.
class GridCell extends StatefulWidget {
  final GridCellStatus status;
  GridCell({
    Key? key,
    required this.gridCellChildMap,
    this.status = GridCellStatus.initial,
    this.animationDuration = const Duration(milliseconds: 500),
  }) : super(key: key);

  final Duration animationDuration;
  
  /// Map of child widgets paired with one [GridCellStatus].
  final Map<GridCellStatus, Widget> gridCellChildMap;
  
  @override
  State<GridCell> createState() => myAppState;

  final myAppState = _GridCellState();

  void updateStatus(GridCellStatus status) {
    myAppState.updateStatus(status);
  }
}

class _GridCellState extends State<GridCell> {
  late GridCellStatus currentStatus;
  void updateStatus(GridCellStatus status) {
    setState(() {
      currentStatus = status;
    });
  }

  @override
  void initState() {
    super.initState();
    currentStatus = widget.status;
  }

  @override
  Widget build(BuildContext context) {
    
    //TODO: check is currentStatus defined
    Widget currentChild = widget.gridCellChildMap[currentStatus]!;
    return AnimatedSwitcher(
      duration: widget.animationDuration,
      child: currentChild,
    );
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
