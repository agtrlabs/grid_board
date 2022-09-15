import 'package:flutter_test/flutter_test.dart';
import 'package:grid_board/grid_board.dart';

void main() {
  test('Gridboard init test', () {
    final gridBoard = GridBoard(
      controller: GridBoardController(
        gridBoardProperties: GridBoardProperties(
          gridSize: const GridSize(4, 4),
        ),
      ),
    );

    expect(gridBoard, isA<GridBoard>());
  });
}
