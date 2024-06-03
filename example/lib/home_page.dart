import 'dart:math';

import 'package:flutter/material.dart';
import 'package:grid_board/grid_board.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GridSize gridSize;
  late GridBoardController gridBoardController;

  final rnd = Random();

  @override
  void initState() {
    super.initState();
    gridSize = const GridSize(7, 9);
    final cells = List<GridCell>.generate(gridSize.cellCount, (index) {
      final char = String.fromCharCode(rnd.nextInt(26) + 65);
      return GridCell(
        controller: GridCellController(
          status:
              rnd.nextBool() ? GridCellStatus.initial : GridCellStatus.selected,
        ),
        gridCellChildMap: {
          GridCellStatus.initial: Container(
            key: ValueKey(index + 1),
            width: 800,
            decoration: BoxDecoration(
              color: const Color(0x99CC3366),
              borderRadius: const BorderRadius.all(Radius.circular(2.0)),
              border: Border.all(
                style: BorderStyle.solid,
                color: const Color(0xFF000000),
              ),
            ),
            //child: FittedBox(child: Text(char)),
          ),
          GridCellStatus.selected: Container(
            width: 800,
            key: ValueKey(index + 2),
            decoration: BoxDecoration(
              color: const Color(0x9922AB50),
              borderRadius: const BorderRadius.all(Radius.circular(2.0)),
              border: Border.all(
                style: BorderStyle.solid,
                color: const Color(0xFF000000),
              ),
            ),
            child: FittedBox(child: Text(char)),
          ),
        },
      );
    });
    GridBoardProperties gridBoardProperties =
        GridBoardProperties(gridSize: gridSize);
    gridBoardController = GridBoardController(
      gridBoardProperties: gridBoardProperties,
      cells: cells,
    );
  }

  @override
  Widget build(BuildContext context) {
    /*for (var i = 0; i < gridSize.cellCount; i++) {
      var cell = GridCell(index: i, stringValue: i.toStringAsFixed(2), child: );
      gridBoardController.cells[i] = cell;
    }*/

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Grid Board Test',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          SizedBox.square(
            dimension: 300,
            child: GridBoard(
              debugMode: false,
              controller: gridBoardController,
              margin: 2,
              onTap: (details) {
                debugPrint("index: ${details.index}");
                debugPrint("grid position: ${details.gridPosition}");
                gridBoardController.animateCell(
                  details.index,
                  repeat: true,
                  repeatCount: 10,
                  animationStyle: PulseAnimation(
                    pulseOpacity: 0,
                    pulseSize: 1.5,
                    pulseInterval: const Duration(seconds: 2),
                    pulseColor: Colors.green,
                  ),
                );
                // gridBoardController.rotate(details.index);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      int from = rnd.nextInt(gridSize.cellCount);
                      int to = rnd.nextInt(gridSize.cellCount);
                      debugPrint(
                          "Send move cmd to controller gridBoardController.move($from, $to);");
                      gridBoardController.moveItem(from, to);
                    },
                    child: const Text('Move an item'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      int from = rnd.nextInt(gridSize.cellCount);
                      int to = rnd.nextInt(gridSize.cellCount);
                      debugPrint(
                          "Send move cmd to controller gridBoardController.move($from, $to);");
                      gridBoardController.moveAllAt(from, to);
                    },
                    child: const Text('Move All'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      int idx = rnd.nextInt(gridSize.cellCount);

                      debugPrint("Rotate gridBoardController.rotate($idx);");
                      gridBoardController.rotate(idx);
                    },
                    child: const Text('Rotate an item'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      int idx = rnd.nextInt(gridSize.cellCount);
                      int status = rnd.nextInt(GridCellStatus.values.length);

                      debugPrint(
                          "Update gridBoardController.updateCellStatus($idx,${GridCellStatus.values[status]});");
                      gridBoardController.updateCellStatus(
                          idx, GridCellStatus.values[status]);
                    },
                    child: const Text('Update Status'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
