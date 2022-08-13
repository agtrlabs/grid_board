import 'dart:math';

import 'package:flutter/material.dart';
import 'package:grid_board/grid_board.dart';




class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GridSize gridSize = const GridSize(4, 4);
    GridBoardProperties gridBoardProperties =
        GridBoardProperties(gridSize: gridSize);
    GridBoardController gridBoardController =
        GridBoardController(
      gridBoardProperties: gridBoardProperties,
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
                margin: 6,
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
                      var rnd = Random(DateTime.now().millisecond);
                      int from = rnd.nextInt(gridSize.cellCount);
                      int to = rnd.nextInt(gridSize.cellCount);
                      print(
                          "Send move cmd to controller gridBoardController.move($from, $to);");
                      gridBoardController.move(from, to);
                    },
                    child: Text('Move a cell'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      var rnd = Random(DateTime.now().millisecond);
                      int idx = rnd.nextInt(gridSize.cellCount);

                      print("Rotate gridBoardController.rotate($idx);");
                      gridBoardController.rotate(idx);
                    },
                    child: Text('Rotate a cell'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      var rnd = Random(DateTime.now().millisecond);
                      int idx = rnd.nextInt(gridSize.cellCount);
                      int status = rnd.nextInt(GridCellStatus.values.length);

                      print(
                          "Update gridBoardController.updateCellStatus($idx,${GridCellStatus.values[status]});");
                      gridBoardController.updateCellStatus(
                          idx, GridCellStatus.values[status]);
                    },
                    child: Text('Update Status of a cell'),
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
