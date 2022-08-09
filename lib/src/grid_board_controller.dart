import 'package:flutter/widgets.dart';
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
    temp = cells[moved.from].index;
    cells[moved.from].index = cells[moved.to].index;
    cells[moved.to].index = temp;
    
  }

  void resetCells(int cellCount) {
    cells = List.generate(
      cellCount,
      (index) => LetterBox(index: index, stringValue: index.toString()),
    );
    for (var i = 0; i < cellCount; i++) {
      cellPositions[i] = i;
    }
  }

  /// get the Grid cell at index
  List<GridCell> cellAt(int index) {
    return cells.where((element) => element.index == index).toList();
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

  GridBoardController({required this.gridBoardProperties}) {
    resetCells(gridBoardProperties.gridSize.cellCount);
  }
}
