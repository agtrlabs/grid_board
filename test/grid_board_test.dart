import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grid_board/grid_board.dart';
import 'package:grid_board/src/grid_board_properties.dart';

void main() {
  test('Gridboard init test', () {
    final gridBoard = GridBoard(
      controller: GridBoardController(
        gridBoardProperties: GridBoardProperties(
          gridSize: const GridSize(4, 4),
        ),
      ),
    );
  });
}
