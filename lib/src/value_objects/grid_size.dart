/// Grid size refers to the number of columns and rows
class GridSize {
  final int colCount;
  final int rowCount;
  int get cellCount => colCount * rowCount;
  const GridSize(this.colCount, this.rowCount);
}
