/// Grid size refers to the number of columns and rows
class GridSize {
  const GridSize(this.colCount, this.rowCount);
  final int colCount;
  final int rowCount;
  int get cellCount => colCount * rowCount;
}
