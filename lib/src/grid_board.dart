import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import 'value_objects/grid_position.dart';
import 'value_objects/grid_tap_details.dart';
import 'value_objects/grid_size.dart';
import 'grid_board_controller.dart';

class GridBoard extends StatefulWidget {
  final Size size;
  final Color backgroundColor;
  final GridSize gridSize;
  final double margin;
  final ValueChanged<GridTapDetails>? onTap;
  final GridBoardController controller;

  /// show border box
  final bool debugmode;

  const GridBoard({
    Key? key,
    required this.size,
    this.backgroundColor = const Color.fromARGB(58, 19, 19, 19),
    this.gridSize = const GridSize(6, 6),
    this.margin = 10,
    this.onTap,
    required this.controller,
    this.debugmode = false,
  }) : super(key: key);

  @override
  State<GridBoard> createState() {
    return _GridBoardState();
  }

  Size get cellSize {
    double space = 0;
    space = (gridSize.colCount + 1) * margin;
    var cellWidth = (size.width - space) / gridSize.colCount;
    space = (gridSize.rowCount + 1) * margin;
    var cellHeight = (size.height - space) / gridSize.rowCount;
    return Size(cellWidth, cellHeight);
  }
}

class _GridBoardState extends State<GridBoard> {
  late Size cellSize;
  late List<Offset> cellPositions;
  late List<double> cellRotations;
  late List<Offset> indexLocations;

  void _calcInitialCellPositions() {
    cellPositions = [];
    cellRotations = [];

    for (var i = 0; i < indexLocations.length; i++) {
      cellPositions.add(Offset(indexLocations[i].dx, indexLocations[i].dy));
      cellRotations.add(0.0);
    }
  }

  /// calculates screen positions of index cells
  void _calcIndexCellPositions() {
    indexLocations = [];
    for (var i = 0;
        i < widget.gridSize.cellCount;
        i++) {
      
      final pos = GridPosition.fromIndex(widget.gridSize, i);

      double offsetX =
          pos.columnIndex * widget.cellSize.width + (pos.columnIndex + 1) * widget.margin;
      double offsetY =
          pos.rowIndex * widget.cellSize.height + (pos.rowIndex + 1) * widget.margin;
      indexLocations.add(Offset(offsetX, offsetY));
    }
  }

  @override
  void initState() {
    super.initState();
    cellSize = widget.cellSize;
    _calcIndexCellPositions();
    _calcInitialCellPositions();

    if (widget.controller.cells.length != widget.gridSize.cellCount) {
      widget.controller.resetCells(widget.gridSize.cellCount);
    }

    widget.controller.addListener(() {
      /*//check cells for move
      for (var i = 0; i < indexLocations.length; i++) {
        int toMove = widget.controller.whereToMove(i);
        if (toMove >= 0) {
          Offset newPosition = indexLocations[toMove];
          setState(() {
            cellPositions[i] = Offset(newPosition.dx, newPosition.dy);
          });
        }
      }*/

      //check cells to move
      widget.controller.cellPositions.forEach((idx, newidx) {
        setState(() {
          Offset newPosition = indexLocations[newidx];
          cellPositions[idx] = Offset(newPosition.dx, newPosition.dy);
        });
      });

      //check cells to rotate
      widget.controller.rotation.forEach((idx, turn) {
        setState(() {
          cellRotations[idx] = turn;
        });
      });

      print("Controller notified");
    });
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  TapUpDetails _tapUpDetails = TapUpDetails(kind: PointerDeviceKind.unknown);

  Widget _gestureDetector() {
    return GestureDetector(
      onTap: () {
        Offset tapped = _tapUpDetails.localPosition;
        int index = cellPositions.indexWhere((element) {
          return (element.dx <= tapped.dx) &&
              (element.dy <= tapped.dy) &&
              (tapped.dx <= element.dx + cellSize.width) &&
              (tapped.dy <= element.dy + cellSize.height);
        });

        if (index >= 0) {
          widget.onTap?.call(GridTapDetails(
              gridPosition: GridPosition.fromIndex(widget.gridSize, index),
              index: index));
        }
      },

      onTapUp: (details) {
        _tapUpDetails = details;
      },
      behavior: HitTestBehavior.opaque,
      // child: Container(
      //   width: widget.size.width,
      //   height: widget.size.height,
      //   color: Color(0x00000000),
      // ),
    );
  }

  Widget _background() {
    return Positioned(
        left: 0,
        top: 0,
        child: Container(
          width: widget.size.width,
          height: widget.size.height,
          color: widget.backgroundColor,
        ));
  }

  @override
  Widget build(BuildContext context) {
    print('Board rebuilded!');
    _calcIndexCellPositions();

    List<Widget> childs = [];

    childs.add(_background());

    if (widget.debugmode) {
      for (var i = 0; i < indexLocations.length; i++) {
        var cp = indexLocations[i];
        var element = Positioned(
          left: cp.dx,
          top: cp.dy,
          child: Container(
            width: widget.cellSize.width,
            height: widget.cellSize.height,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromARGB(255, 255, 0, 0), // red as border color
              ),
            ),
          ),
        );
        childs.add(element);
      }
    }
    for (var i = 0; i < cellPositions.length; i++) {
      var currentCell = widget.controller.cells[i];

      childs.add(AnimatedPositioned(
          left: cellPositions[i].dx,
          top: cellPositions[i].dy,
          curve: Curves.elasticInOut,
          duration: const Duration(seconds: 1),
          child: AnimatedRotation(
            turns: cellRotations[i],
            curve: Curves.easeOutCubic,
            duration: const Duration(milliseconds: 600),
            child: SizedBox(
              width: widget.cellSize.width,
              height: widget.cellSize.height,
              child: currentCell,
            ),
          )));
    }

    childs.add(_gestureDetector());
    return Stack(
      children: childs,
    );
  }
}
