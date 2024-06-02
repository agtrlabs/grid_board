import 'package:flutter/foundation.dart';
import 'package:grid_board/src/grid_cell_status.dart';

class GridCellController extends ChangeNotifier {
  GridCellController({GridCellStatus? status})
      : _status = status ?? GridCellStatus.initial;
  GridCellStatus _status;

  GridCellStatus get status => _status;

  void updateStatus(GridCellStatus newStatus) {
    if (_status != newStatus) {
      _status = newStatus;
      notifyListeners();
    }
  }
}
