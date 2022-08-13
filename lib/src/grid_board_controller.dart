import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grid_board/src/grid_cell_status.dart';
import '../src/grid_board_properties.dart';
import '../src/grid_cell.dart';
import '../src/value_objects/move_to_data.dart';

class GridBoardController extends ChangeNotifier {
  List<GridCell> cells = [];
  List<MoveToData> moveToList = [];
  Map<int, double> rotation = {};
  Map<int, int> cellPositions = {};
  final GridBoardProperties gridBoardProperties;

  void move(int fromIndex, int toIndex, {Curve curve = Curves.elasticInOut}) {
    moveToList.add(MoveToData(fromIndex, toIndex, curve: curve));
    cellPositions[fromIndex] = toIndex;
    notifyListeners();
  }

  void updateMoved(MoveToData moved) {
    moveToList.removeWhere((element) => element == moved);
    var temp;
    temp = cells[moved.from];
    cells[moved.from] = cells[moved.to];
    cells[moved.to] = temp;
  }

  void resetCells(int cellCount) {
    cells = List.generate(
      cellCount,
      (index) => GridCell(
        gridCellChildMap: {
          GridCellStatus.initial: Container(
            key: ValueKey(index + 1),
            width: 800,
            color: Colors.red,
            child: FittedBox(child: Text('$index')),
          ),
          GridCellStatus.selected: Container(
              width: 800,
              key: ValueKey(index + 2),
              color: Colors.green,
              child: FittedBox(child: Text('${index + 16}'))),
        },
      ),
    );
    for (var i = 0; i < cellCount; i++) {
      cellPositions[i] = i;
      //cells[i].updateStatus(GridCellStatus.initial);
    }
  }

  /// get the Grid cell at index
  List<GridCell> cellAt(int index) {
    return cells.where((element) => element.hashCode == index).toList();
  }

  // returns where to move the element at fromIndex
  // if it doesn't in te moveToList function returns -1
  int whereToMove(int fromIndex) {
    return moveToList
        .firstWhere((e) => e.from == fromIndex,
            orElse: () => MoveToData(fromIndex, -1))
        .to;
  }

  void rotate(int index, [double turns = 0.25]) {
    rotation[index] = (rotation[index] ?? 0) + turns;
    notifyListeners();
  }

  void cleanRotation(int index) {
    rotation.remove(index);
  }

  void updateCellStatus(int index, GridCellStatus status) {
    cells[index].updateStatus(status);
  }

  GridBoardController(
      {required this.gridBoardProperties, List<GridCell>? cells}) {
    if (cells == null) {
      resetCells(gridBoardProperties.gridSize.cellCount);
    } else {
      this.cells = cells;
    }

    print('gridBoardController Create');
  }
}
