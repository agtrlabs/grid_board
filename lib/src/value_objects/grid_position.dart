import 'package:grid_board/grid_board.dart';

/// Specifies the row and column index of a grid cell
class GridPosition {
  const GridPosition({required this.columnIndex, required this.rowIndex});

  factory GridPosition.fromIndex(GridSize size, int index) {
    final row = index % size.rowCount;
    final col = (index / size.rowCount).floor();
    return GridPosition(columnIndex: col, rowIndex: row);
  }
  final int columnIndex;
  final int rowIndex;

  @override
  String toString() {
    return 'GridPosition[columnIndex:$columnIndex, rowIndex:$rowIndex]';
  }

  int toIndex(GridSize size) {
    return (size.colCount * rowIndex) + columnIndex;
  }
}
