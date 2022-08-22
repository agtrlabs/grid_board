import 'dart:math';

import 'package:flutter/material.dart';
import 'package:grid_board/grid_board.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rnd = Random();
    GridSize gridSize = const GridSize(5, 5);
    final cells = List<GridCell>.generate(gridSize.cellCount, (index) {
      final char = String.fromCharCode(rnd.nextInt(26) + 65);
      return GridCell(
        status:
            rnd.nextBool() ? GridCellStatus.initial : GridCellStatus.selected,
        gridCellChildMap: {
          GridCellStatus.initial: Container(
            key: ValueKey(index + 1),
            width: 800,
            decoration: const BoxDecoration(
              color: Color(0x99CC3366),
            ),
            child: FittedBox(child: Text(char)),
          ),
          GridCellStatus.selected: Container(
            width: 800,
            key: ValueKey(index + 2),
            decoration: const BoxDecoration(
              color: Color(0x9922AB50),
            ),
            child: FittedBox(child: Text(char)),
          ),
        },
      );
    });
    GridBoardProperties gridBoardProperties =
        GridBoardProperties(gridSize: gridSize);
    GridBoardController gridBoardController = GridBoardController(
      gridBoardProperties: gridBoardProperties,
      cells: cells,
    );

    /*for (var i = 0; i < gridSize.cellCount; i++) {
      var cell = GridCell(index: i, stringValue: i.toStringAsFixed(2), child: );
      gridBoardController.cells[i] = cell;
    }*/

    return Scaffold(
      body: LayoutBuilder(builder: (context, boxCints) {
        print('Screen resized!');
        double square = min(boxCints.maxWidth, boxCints.maxHeight);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Grid Board Test',
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            Expanded(
              child: GridBoard(
                debugmode: true,
                controller: gridBoardController,
                size: Size(square, square),
                gridSize: gridSize,
                margin: 0,
                onTap: (details) {
                  print("index: ${details.index}");
                  print("grid position: ${details.gridPosition}");
                  gridBoardController.rotate(details.index);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      
                      int from = rnd.nextInt(gridSize.cellCount);
                      int to = rnd.nextInt(gridSize.cellCount);
                      print(
                          "Send move cmd to controller gridBoardController.move($from, $to);");
                      gridBoardController.moveItem(from, to);
                    },
                    child: Text('Move an item'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      
                      int from = rnd.nextInt(gridSize.cellCount);
                      int to = rnd.nextInt(gridSize.cellCount);
                      print(
                          "Send move cmd to controller gridBoardController.move($from, $to);");
                      gridBoardController.moveAllAt(from, to);
                    },
                    child: Text('Move All'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      
                      int idx = rnd.nextInt(gridSize.cellCount);

                      print("Rotate gridBoardController.rotate($idx);");
                      gridBoardController.rotate(idx);
                    },
                    child: Text('Rotate an item'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      
                      int idx = rnd.nextInt(gridSize.cellCount);
                      int status = rnd.nextInt(GridCellStatus.values.length);

                      print(
                          "Update gridBoardController.updateCellStatus($idx,${GridCellStatus.values[status]});");
                      gridBoardController.updateCellStatus(
                          idx, GridCellStatus.values[status]);
                    },
                    child: Text('Update Status'),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
