import 'package:flutter/widgets.dart';
import 'grid_cell_status.dart';

typedef GridCellBuilder = Widget Function(GridCellStatus status);

class GridCell extends StatefulWidget {
  final GridCellStatus status;
  GridCell({
    Key? key,
    required this.gridCellChildMap,
    this.status = GridCellStatus.initial,
    this.animatiodDuration = const Duration(milliseconds: 1000),
  }) : super(key: key);

  final Duration animatiodDuration;
  final Map<GridCellStatus, Widget> gridCellChildMap;
  @override
  State<GridCell> createState() => myAppState;

  final _GridCellState myAppState = _GridCellState();

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
    Widget currentChild = widget.gridCellChildMap[currentStatus]!;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
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