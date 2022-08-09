/// Specifies the row and column index of a grid cell
class GridPosition {
  final int columnIndex;
  final int rowIndex;
  const GridPosition({required this.columnIndex, required this.rowIndex});

  @override
  String toString() {
    return "GridPosition[columnIndex:$columnIndex, rowIndex:$rowIndex]";
  }
}