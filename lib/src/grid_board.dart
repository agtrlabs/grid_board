import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import 'package:grid_board/src/grid_board_controller.dart';
import 'package:grid_board/src/value_objects/grid_position.dart';
import 'package:grid_board/src/value_objects/grid_size.dart';
import 'package:grid_board/src/value_objects/grid_tap_details.dart';

class GridBoard extends StatefulWidget {
  const GridBoard({
    required this.controller,
    super.key,
    this.backgroundColor = const Color.fromARGB(58, 19, 19, 19),
    this.margin = 2,
    this.onTap,
    this.debugMode = false,
  });
  final Color backgroundColor;
  final double margin;
  final ValueChanged<GridTapDetails>? onTap;
  final GridBoardController controller;

  /// Debug mode will show border box of cells
  final bool debugMode;

  @override
  State<GridBoard> createState() {
    return _GridBoardState();
  }
}

class _GridBoardState extends State<GridBoard> {
  Size? size;
  late List<Offset> cellPositions;
  late List<double> cellRotations;
  late List<Offset> indexLocations;
  int setter = 0;

  GridSize get gridSize => widget.controller.gridBoardProperties.gridSize;

  void _calcInitialCellPositions() {
    if (setter == 0) {
      cellRotations = [];
      cellPositions = [];
    }

    for (var i = 0; i < indexLocations.length; i++) {
      final location = indexLocations[i];
      if (setter == 0) {
        cellRotations.add(0);
        cellPositions.add(location);
      } else {
        cellPositions[i] = location;
      }
    }
    Future.delayed(Duration.zero, () {
      widget.controller.cellPositions.forEach((idx, newIdx) {
        setState(() {
          final newPosition = indexLocations[newIdx];
          cellPositions[idx] = newPosition;
        });
      });
    });
    if (setter < 1) {
      setter += 1;
    }
  }

  /// calculates screen positions of index cells
  void _calcIndexCellPositions({
    required Size cellSize,
    required Size screenSize,
  }) {
    indexLocations = [];
    final totalWidth =
        gridSize.colCount * (cellSize.width + widget.margin) + widget.margin;
    final totalHeight =
        gridSize.rowCount * (cellSize.height + widget.margin) + widget.margin;
    final extraSpaceHor = ((screenSize.width - totalWidth) / 2 > 0)
        ? (screenSize.width - totalWidth) / 2
        : 0;
    final extraSpaceVer = ((screenSize.height - totalHeight) / 2 > 0)
        ? (screenSize.height - totalHeight) / 2
        : 0;

    for (var i = 0; i < gridSize.cellCount; i++) {
      final pos = GridPosition.fromIndex(gridSize, i);

      final offsetX = extraSpaceHor +
          (pos.columnIndex * cellSize.width) +
          ((pos.columnIndex + 1) * widget.margin);
      final offsetY = extraSpaceVer +
          (pos.rowIndex * cellSize.height) +
          ((pos.rowIndex + 1) * widget.margin);
      indexLocations.add(Offset(offsetX, offsetY));
    }
  }

  @override
  void initState() {
    _calcIndexCellPositions(
      cellSize: const Size(10, 10),
      screenSize: const Size(50, 50),
    );
    _calcInitialCellPositions();
    super.initState();
    if (widget.controller.cells.length != gridSize.cellCount) {
      widget.controller.resetCells(gridSize.cellCount);
    }

    widget.controller.addListener(() {
      //check cells to move
      widget.controller.cellPositions.forEach((idx, newIdx) {
        setState(() {
          final newPosition = indexLocations[newIdx];
          cellPositions[idx] = newPosition;
        });
      });

      //check cells to rotate
      widget.controller.rotation.forEach((idx, turn) {
        setState(() {
          cellRotations[idx] = turn;
        });
      });
    });
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  TapUpDetails _tapUpDetails = TapUpDetails(kind: PointerDeviceKind.unknown);

  Widget _gestureDetector({required Size cellSize}) {
    return GestureDetector(
      onTap: () {
        debugPrint('Tapped!');
        final tapped = _tapUpDetails.localPosition;
        final index = cellPositions.indexWhere((element) {
          return (element.dx <= tapped.dx) &&
              (element.dy <= tapped.dy) &&
              (tapped.dx <= element.dx + cellSize.width) &&
              (tapped.dy <= element.dy + cellSize.height);
        });

        if (index >= 0) {
          debugPrint('greater than 0');
          widget.onTap?.call(
            GridTapDetails(
              gridPosition: GridPosition.fromIndex(gridSize, index),
              index: index,
            ),
          );
        }
      },
      onTapUp: (details) {
        _tapUpDetails = details;
      },
      behavior: HitTestBehavior.opaque,
    );
  }

  Widget _background({required Size size}) {
    return Positioned(
      left: 0,
      top: 0,
      child: Container(
        width: size.width,
        height: size.height,
        color: widget.backgroundColor,
      ),
    );
  }

  Positioned indexLocationElement({
    required Offset cp,
    required Size cellSize,
  }) {
    return Positioned(
      left: cp.dx,
      top: cp.dy,
      child: Container(
        width: cellSize.width,
        height: cellSize.height,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(255, 255, 0, 0),
          ),
        ),
      ),
    );
  }

  List<Widget> rebuild({required Size size, required Size cellSize}) {
    final children = <Widget>[_background(size: size)];

    if (widget.debugMode) {
      for (final location in indexLocations) {
        final element = indexLocationElement(cp: location, cellSize: cellSize);
        children.add(element);
      }
    }
    for (var i = 0; i < cellPositions.length; i++) {
      final currentCell = widget.controller.cells[i];
      children.add(
        AnimatedPositioned(
          left: cellPositions[i].dx,
          top: cellPositions[i].dy,
          curve: Curves.elasticInOut,
          duration: const Duration(seconds: 1),
          child: AnimatedRotation(
            turns: cellRotations[i],
            curve: Curves.easeOutCubic,
            duration: const Duration(milliseconds: 600),
            child: SizedBox(
              width: cellSize.width,
              height: cellSize.height,
              child: currentCell,
            ),
          ),
        ),
      );
    }
    children.add(_gestureDetector(cellSize: cellSize));
    return children;
  }

  Size? _cellSize;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        debugPrint('Board rebuilt');

        final size = Size(constraints.maxWidth, constraints.maxHeight);
        Size cellSize() {
          var space = 0.0;
          space = (gridSize.colCount + 1) * widget.margin;
          final cellWidth = (size.width - space) / gridSize.colCount;
          space = (gridSize.rowCount + 1) * widget.margin;
          final cellHeight = (size.height - space) / gridSize.rowCount;
          final double square = min(cellWidth, cellHeight);
          return Size(square, square);
        }

        if (_cellSize != cellSize()) {
          _calcIndexCellPositions(
            cellSize: cellSize(),
            screenSize: Size(constraints.maxWidth, constraints.maxHeight),
          );
          _calcInitialCellPositions();
          _cellSize = cellSize();
        }
        return Stack(
          children: rebuild(cellSize: cellSize(), size: size),
        );
      },
    );
  }
}
