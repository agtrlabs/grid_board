import 'package:grid_board/src/value_objects/grid_position.dart';

class GridTapDetails {
  GridTapDetails({
    required this.gridPosition,
    required this.index,
  });

  final int index;
  final GridPosition gridPosition;
}
