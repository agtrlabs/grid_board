import 'package:grid_board/grid_board.dart';

/// Specifies the row and column index of a grid cell
class GridPosition {
  final int columnIndex;
  final int rowIndex;
  const GridPosition({required this.columnIndex, required this.rowIndex});

  @override
  String toString() {
    return "GridPosition[columnIndex:$columnIndex, rowIndex:$rowIndex]";
  }

  int toIndex(GridSize size){
    return (size.colCount * rowIndex) + columnIndex;
  }

  factory GridPosition.fromIndex(GridSize size, int index) {
    int row = index % size.colCount;
    int col = (index / size.colCount).floor();
    return GridPosition(columnIndex: col, rowIndex: row);
  }
}