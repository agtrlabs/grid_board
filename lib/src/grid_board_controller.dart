import 'package:flutter/material.dart';

import '../grid_board.dart';

class GridBoardController extends ChangeNotifier {
  List<GridCell> cells = [];
  List<MoveToData> moveToList = [];

  /// Map for "Gridcell index" to "rotation"
  Map<int, double> rotation = {};

  /// Map for "Gridcell index" to "Position index"
  Map<int, int> cellPositions = {};

  final GridBoardProperties gridBoardProperties;

  void moveItem(int fromIndex, int toIndex,
      {Curve curve = Curves.elasticInOut}) {
    moveToList.add(MoveToData(fromIndex, toIndex, curve: curve));
    cellPositions[fromIndex] = toIndex;
    notifyListeners();
  }

  void moveAllAt(int fromIndex, int toIndex,
      {Curve curve = Curves.elasticInOut}) {
    cellPositions.forEach((key, value) {
      if (value == fromIndex) {
        moveItem(key, toIndex);
      }
    });
  }

  void updateMoved(MoveToData moved) {
    moveToList.removeWhere((element) => element == moved);
    var temp;
    temp = cells[moved.item];
    cells[moved.item] = cells[moved.to];
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
  }

  void initialPositions() {
    for (var i = 0; i < cells.length; i++) {
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
        .firstWhere((e) => e.item == fromIndex,
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

  Map<GridPosition, CellValue> values() {
    return {};
  }

  GridBoardController(
      {required this.gridBoardProperties, List<GridCell>? cells}) {
    if (cells == null) {
      resetCells(gridBoardProperties.gridSize.cellCount);
    } else {
      this.cells = cells;
    }
    initialPositions();

    print('gridBoardController Create');
  }
}
