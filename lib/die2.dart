import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'face1.dart';
import 'face2.dart';
import 'face3.dart';
import 'face4.dart';
import 'face5.dart';
import 'face6.dart';

class Die2 extends StatelessWidget {
  final double degrees = 0.0;
  final Matrix4 perspective = _pmat(1.0);

  static Matrix4 _pmat(num pv) {
    return new Matrix4(
      1.0, 0.0, 0.0, 0.0, //
      0.0, 1.0, 0.0, 0.0, //
      0.0, 0.0, 1.0, pv * 0.001, //
      0.0, 0.0, 0.0, 1.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Transform.scale(
        scale: 0.65,
        child: PhysicalModel(
            color: Colors.transparent,
            elevation: 20,
            shadowColor: Colors.redAccent,
            child: Stack(
              children: <Widget>[
                // Face Back 5
                Transform(
                    child: Face5(),
                    alignment: FractionalOffset.center,
                    transform: perspective.scaled(0.84, 0.84, 1.0)
                      // rotate X 180
                      ..rotateX(math.pi - degrees * math.pi / 180)
                      ..rotateY(0.0)
                      ..rotateZ(0.0)),
                // Face Top 1
                Transform(
                    child: Face1(),
                    alignment: FractionalOffset.topCenter,
                    transform: perspective.scaled(1.0, 1.0, 1.0)
                      ..rotateX(1.47)
                      ..rotateY(0.0)
                      ..rotateZ(0.0)),
                // Face Bottom 6
                Transform(
                    child: Face6(),
                    alignment: FractionalOffset.bottomCenter,
                    transform: perspective.scaled(1.0, 1.0, 1.0)
                      ..rotateX(-1.47)
                      ..rotateY(0.0)
                      ..rotateZ(0.0)),
                // Face Left 3
                Transform(
                    child: Face3(),
                    alignment: FractionalOffset.centerLeft,
                    transform: perspective.scaled(1.0, 1.0, 1.0)
                      ..rotateX(0.0)
                      ..rotateY(-1.47)
                      ..rotateZ(0.0)),
                // Face Right 4
                Transform(
                    child: Face4(),
                    alignment: FractionalOffset.centerRight,
                    transform: perspective.scaled(1.0, 1.0, 1.0)
                      ..rotateX(0.0)
                      ..rotateY(1.47)
                      ..rotateZ(0.0)),
                // Face Front 2
                Transform(
                    child: Face2(),
                    alignment: FractionalOffset.center,
                    transform: perspective.scaled(1.0, 1.0, 1.0)
                      ..rotateX(0.0)
                      ..rotateY(0.0)
                      ..rotateZ(0.0)),
              ],
            )),
      ),
    );
  }
}
