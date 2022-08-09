import 'package:flutter/widgets.dart';

class MoveToData {
  final int from;
  final int to;
  final Curve curve;
  const MoveToData(this.from, this.to, {this.curve = Curves.elasticInOut});

  @override
  bool operator ==(Object o) => o is MoveToData && from == o.from && to == o.to;

  @override
  int get hashCode => from * 1000 + to;
}
