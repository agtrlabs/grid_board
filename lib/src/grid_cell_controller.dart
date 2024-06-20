import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:grid_board/src/grid_cell_status.dart';
import 'package:grid_board/src/value_objects/animation_style.dart';

class GridCellController extends ChangeNotifier {
  GridCellController({GridCellStatus? status})
      : _status = status ?? GridCellStatus.initial;
  GridCellStatus _status;

  GridCellStatus get status => _status;

  // we want to accommodate the animation, so that from the
  // GridBoardController, we can onAnimate, use the cell[cellIndex] and set
  // an animation here and trigger a rebuild of the GridCell widget

  CellAnimationStyle? _animationStyle;

  CellAnimationStyle? get animationStyle => _animationStyle;

  int? _repeatCount;

  int? get repeatCount => _repeatCount;

  bool _repeat = false;

  bool get repeat => _repeat;

  late AnimationController _animationController;

  AnimationController get animationController => _animationController;

  bool _initialized = false;

  int _repeatCounter = 0;

  void initAnimationController(TickerProvider vsync) {
    if (_initialized) return;
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: vsync,
    );
    _animationController.addStatusListener((status) {
      switch (_animationStyle) {
        case PulseAnimation():
          pulseStatusHandler(status);
        case null:
          break;
        case RotateAnimation():
        // TODO: Handle this case.
        case ScaleAnimation():
        // TODO: Handle this case.
        case SlideAnimation():
        // TODO: Handle this case.
        case SpinAnimation():
        // TODO: Handle this case.
        case ZoomAnimation():
        // TODO: Handle this case.
        case CustomAnimation():
        // TODO: Handle this case.
      }
    });
    _initialized = true;
  }

  void pulseStatusHandler(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      _repeatCounter++;
      if (_repeat && (_repeatCount == null || _repeatCounter < _repeatCount!)) {
        _animationController.forward();
      } else {
        _repeatCounter = 0;
      }
    } else if (status == AnimationStatus.completed) {
      if (_repeat &&
          (_repeatCount == null || _repeatCounter < _repeatCount! - 1)) {
        // we want to use the pulse.interval to determine the delay
        // before the next pulse

        final pulseInterval =
            (_animationStyle! as PulseAnimation).pulseInterval;
        Future.delayed(pulseInterval, () {
          _animationController.reverse(from: .00001);
        });
      }
    }
  }

  void setAnimationStyle({
    required CellAnimationStyle animationStyle,
    bool repeat = false,
    int? repeatCount,
  }) {
    _animationStyle = animationStyle;
    _repeat = repeat;
    _repeatCount = repeatCount;
    notifyListeners();
  }

  void startAnimation() {
    if (_animationStyle != null) {
      _animationController.forward();
    }
  }

  void stopAnimation() {
    if (_animationStyle != null) {
      _animationController.stop();
    }
  }

  void updateStatus(GridCellStatus newStatus) {
    if (_status != newStatus) {
      _status = newStatus;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
