import 'package:flutter/widgets.dart';

class GridCell {
  int index;
  String stringValue;
  Widget child;
  GridCell({
    required this.index,
    this.child = const Text(''),
    this.stringValue = '',
  });
}

class LetterBox extends GridCell {
  LetterBox({required super.index, super.stringValue}) {
    child = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0x66AABBCC),
          border: Border.all(
            color: Color(0xFF111111),
            width: 3,
          ),
        ),
        child: FittedBox(child: Text(stringValue)));
  }
}
