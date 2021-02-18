import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graphic/graphic.dart' as graphic;

class TargetNetwork extends StatelessWidget {
  final Color activeColor = Color(0xFFFE903F);
  final Color inActiveColor = Color(0xFFBCB0AC);

  final scatterDataTest = [
    [70, 'tf', 4500, 't', 10],
    [180, 'tf', 500, 't', 50],
    [90, 'tf', 6600, 't', 50]
  ];

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        child: Text('Availability of Targets', style: TextStyle(fontSize: 20)),
        padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
      ),
      Container(
        width: 350,
        height: 300,
        child: graphic.Chart(
          data: scatterDataTest,
          scales: {
            '0': graphic.LinearScale(
              accessor: (list) => list[0] as num,
              nice: true,
              min: 0,
              max: 360,
              tickCount: 36,
              tickInterval: 10,
            ),
            '1': graphic.LinearScale(
                accessor: (list) => list[2] as num,
                nice: true,
                // min: 0,
                // max: 5000,
                tickCount: 5,
                tickInterval: 1000,
                ticks: [0, 1000, 2000, 3000, 4000, 5000],
                alias: 'm'),
            '2': graphic.CatScale(
              accessor: (list) => list[4].toString(),
            ),
            '4': graphic.CatScale(
              accessor: (list) => list[3].toString(),
            ),
          },
          coord: graphic.PolarCoord(),
          geoms: [
            graphic.PointGeom(
                position: graphic.PositionAttr(field: '0*1'),
                size: graphic.SizeAttr(field: '2', values: [3, 7]),
                color: graphic.ColorAttr(field: '4'))
          ],
          axes: {
            '0': graphic.Defaults.circularAxis,
            '1': graphic.Defaults.radialAxis,
          },
        ),
      ),
    ]);
  }
}
