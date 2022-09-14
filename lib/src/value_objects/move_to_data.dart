import 'package:flutter/widgets.dart';

class MoveToData {
  /// id / index of GridCell item
  final int item;

  /// index of position
  final int to;
  // animation curve
  final Curve curve;
  const MoveToData(this.item, this.to, {this.curve = Curves.elasticInOut});

  @override
  bool operator ==(Object other) =>
      other is MoveToData && item == other.item && to == other.to;

  @override
  int get hashCode => item * 1000 + to;
}
